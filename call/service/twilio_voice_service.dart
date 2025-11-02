// lib/features/call/service/twilio_voice_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Hoher Level: spiegelt Zustände wider, die die UI verstehen kann.
enum CallState { idle, connecting, ringing, connected, reconnecting, failed, ended }

class TwilioVoiceService {
  static const MethodChannel _m = MethodChannel('loadum/twilio_voice');
  static const EventChannel  _e = EventChannel('loadum/twilio_voice_events');

  // --- Public streams --------------------------------------------------------
  final _stateCtrl = StreamController<CallState>.broadcast();
  final _eventCtrl = StreamController<Map<String, dynamic>>.broadcast();

  /// Nur der Status (für UI-Labels/Badges).
  Stream<CallState> get stateStream => _stateCtrl.stream;

  /// Rohere Events (falls du später mehr Details brauchst).
  Stream<Map<String, dynamic>> get eventStream => _eventCtrl.stream;

  // --- Internals -------------------------------------------------------------
  bool _nativeAvailable = false;
  bool get isNativeAvailable => _nativeAvailable;

  String? _currentCallId;
  DateTime? _tokenExpiry;
  CallState _lastState = CallState.idle;

  // ===========================================================================
  // Init / Events
  // ===========================================================================
  Future<bool> init(String token) async {
    try {
      await _m.invokeMethod('init', {'token': token});
      _nativeAvailable = true;
      _subscribeNativeEvents();
      _emitState(CallState.idle);
      return true;
    } on MissingPluginException {
      // Kein natives Layer → Stub-Modus aktivieren
      debugPrint('Twilio native layer not found. Running in stub mode.');
      _nativeAvailable = false;
      _emitState(CallState.idle);
      return true; // UI darf trotzdem laufen
    } catch (e) {
      debugPrint('voice init failed: $e');
      _nativeAvailable = false;
      _emitState(CallState.failed);
      return false;
    }
  }

  void _subscribeNativeEvents() {
    _e.receiveBroadcastStream().listen((dynamic evt) {
      try {
        final parsed = _normalizeEvent(evt);
        final s = _map(parsed['state']?.toString() ?? '');
        if (parsed.containsKey('callId'))   _currentCallId = parsed['callId']?.toString();
        if (parsed.containsKey('tokenExpiry')) {
          _tokenExpiry = _parseDateOrMillis(parsed['tokenExpiry']);
        }
        _emitState(s);
        _eventCtrl.add(parsed);
      } catch (err) {
        debugPrint('voice events parsing error: $err');
      }
    }, onError: (err) {
      debugPrint('voice events error: $err');
    });
  }

  Map<String, dynamic> _normalizeEvent(dynamic evt) {
    if (evt == null) return <String, dynamic>{};
    if (evt is Map) {
      // Cast keys/values zu Strings/dynamisch
      return evt.map((k, v) => MapEntry(k.toString(), v));
    }
    // Falls die Bridge nur einen String sendet (z. B. "connected")
    return <String, dynamic>{'state': evt.toString()};
  }

  // ===========================================================================
  // Calling
  // ===========================================================================
  /// Bevorzugt: Startet einen Call. Liefert eine Call-ID (oder Dummy im Stub).
  Future<String> startCall({
    required String to,
    String? from,
    String? note,
    bool autoNumber = false,
  }) async {
    if (!_nativeAvailable) {
      // Stub: simuliere Ablauf
      _emitState(CallState.connecting);
      await Future.delayed(const Duration(milliseconds: 600));
      _emitState(CallState.connected);
      _currentCallId = DateTime.now().millisecondsSinceEpoch.toString();
      return _currentCallId!;
    }

    try {
      dynamic res;
      try {
        // Idealerweise stellt das Native-SDK eine explizite startCall-API bereit
        res = await _m.invokeMethod('startCall', {
          'to': to,
          if (from != null) 'from': from,
          if (note != null && note.isNotEmpty) 'note': note,
          'autoNumber': autoNumber,
        });
      } on MissingPluginException {
        // Fallback auf "connect" falls keine "startCall"-Methode existiert
        res = await _m.invokeMethod('connect', {'to': to});
      }

      final callId = _extractCallId(res);
      _currentCallId = callId;
      return callId;
    } catch (e) {
      _emitState(CallState.failed);
      rethrow;
    }
  }

  /// Alternativer Einstieg (Kompatibilität): "connect" → bool Erfolg
  Future<bool> connect({required String toNumber}) async {
    if (!_nativeAvailable) {
      _emitState(CallState.connecting);
      await Future.delayed(const Duration(milliseconds: 600));
      _emitState(CallState.connected);
      _currentCallId = DateTime.now().millisecondsSinceEpoch.toString();
      return true;
    }
    final ok = await _m.invokeMethod('connect', {'to': toNumber});
    return ok == true;
  }

  /// Call beenden.
  Future<void> endCall() async {
    if (!_nativeAvailable) {
      _emitState(CallState.ended);
      return;
    }
    try {
      try {
        await _m.invokeMethod('endCall');
      } on MissingPluginException {
        await _m.invokeMethod('disconnect');
      }
    } finally {
      _emitState(CallState.ended);
    }
  }

  /// Alternativer Name (Kompatibilität).
  Future<void> disconnect() => endCall();

  // ===========================================================================
  // Audio / Recording
  // ===========================================================================
  Future<void> mute(bool v) async {
    if (!_nativeAvailable) return;
    try {
      // bevorzugt "mute" mit 'muted'
      await _m.invokeMethod('mute', {'muted': v});
    } on MissingPluginException {
      // Fallback: unterschiedliche Bridges nutzen evtl. andere Namen
      await _m.invokeMethod('setMute', {'muted': v});
    }
  }

  Future<void> speaker(bool v) async {
    if (!_nativeAvailable) return;
    try {
      await _m.invokeMethod('speaker', {'on': v});
    } on MissingPluginException {
      await _m.invokeMethod('setSpeaker', {'on': v});
    }
  }

  Future<void> record(bool v) async {
    if (!_nativeAvailable) return;
    try {
      await _m.invokeMethod('record', {'on': v});
    } catch (e) {
      // Optional – nicht jede Bridge unterstützt Recording
      debugPrint('record() not supported or failed: $e');
    }
  }

  /// Kompatibilität zu bestehendem Code (falls du toggle.. statt bool-Setter nutzt)
  Future<void> toggleMute(bool muted) => mute(muted);
  Future<void> toggleSpeaker(bool on)  => speaker(on);

  // ===========================================================================
  // Token / Meta
  // ===========================================================================
  Future<DateTime?> getTokenExpiry() async {
    if (!_nativeAvailable) return _tokenExpiry;
    try {
      final res = await _m.invokeMethod('getTokenExpiry');
      // Kann int (Millis), String (ISO) oder null sein
      return _parseDateOrMillis(res) ?? _tokenExpiry;
    } catch (_) {
      return _tokenExpiry;
    }
  }

  String? get currentCallId => _currentCallId;

  // ===========================================================================
  // Helpers
  // ===========================================================================
  void _emitState(CallState s) {
    _lastState = s;
    if (!_stateCtrl.isClosed) {
      _stateCtrl.add(s);
    }
  }

  String _extractCallId(dynamic res) {
    if (res == null) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
    if (res is String) return res;
    if (res is Map) {
      final v = res['callId'] ?? res['id'] ?? res['sid'];
      if (v != null) return v.toString();
    }
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  DateTime? _parseDateOrMillis(dynamic v) {
    try {
      if (v == null) return null;
      if (v is int) {
        // millis since epoch
        return DateTime.fromMillisecondsSinceEpoch(v);
      }
      final s = v.toString();
      // evtl. ISO-String
      return DateTime.tryParse(s);
    } catch (_) {
      return null;
    }
  }

  CallState _map(String s) {
    switch (s) {
      case 'connecting':    return CallState.connecting;
      case 'ringing':       return CallState.ringing;
      case 'connected':     return CallState.connected;
      case 'reconnecting':  return CallState.reconnecting;
      case 'failed':        return CallState.failed;
      case 'ended':         return CallState.ended;
      case 'idle':
      default:              return CallState.idle;
    }
  }

  // ===========================================================================
  // Lifecycle
  // ===========================================================================
  void dispose() {
    _stateCtrl.close();
    _eventCtrl.close();
  }
}
