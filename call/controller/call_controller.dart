// lib/features/call/controller/call_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/call_repo.dart';
// Wichtig: vermeidet Enum-Kollision mit Service (du hast Variante A gewählt)
import '../service/twilio_voice_service.dart' hide CallState;

/// Enum für den Dialer + erweitertes UI
enum CallState { idle, connecting, ringing, connected, reconnecting, failed, ended }

class CallLogEntry {
  final String toNumber;
  final String fromNumber;
  final DateTime startedAt;
  final Duration duration;
  final String outcome; // z.B. "Ended", "Failed", "Missed"
  final String? callId;

  CallLogEntry({
    required this.toNumber,
    required this.fromNumber,
    required this.startedAt,
    required this.duration,
    required this.outcome,
    this.callId,
  });

  String get startedAtStr {
    final y = startedAt.year.toString().padLeft(4, '0');
    final mo = startedAt.month.toString().padLeft(2, '0');
    final d = startedAt.day.toString().padLeft(2, '0');
    final h = startedAt.hour.toString().padLeft(2, '0');
    final m = startedAt.minute.toString().padLeft(2, '0');
    return '$y-$mo-$d  $h:$m';
  }

  String get formattedDuration {
    final mm = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = duration.inHours;
    return hh > 0 ? '$hh:$mm:$ss' : '$mm:$ss';
  }
}

class CallController extends GetxController {
  final CallRepo callRepo;
  final TwilioVoiceService voice;

  CallController({required this.callRepo, required this.voice});

  // ===== Inputs
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController noteCtrl  = TextEditingController();
  final FocusNode phoneFocus = FocusNode();

  // ===== Outbound management (für erweiterten Screen)
  List<String> fromNumbers = const ['Company default'];
  String selectedFromNumber = 'Company default';
  bool autoNumberingEnabled = false;

  // ===== UI State
  bool isCalling = false; // Verbindungsaufbau läuft
  bool inCall = false;    // Verbunden

  // Intern + kompatible Aliase (Dialer nutzt isMuted; Screen nutzt muted)
  bool _muted = false;
  bool _speakerOn = false;
  bool _recordingEnabled = false;

  bool get muted => _muted;
  set muted(bool v) => _muted = v;

  bool get isMuted => _muted; // Alias für alten Dialer
  bool get speakerOn => _speakerOn;
  bool get recordingEnabled => _recordingEnabled;

  // ===== Status/Meta
  CallState callState = CallState.idle; // Zustandsmaschine
  String statusLabel = 'Idle';          // Kurzer Text fürs UI
  String? currentCallId;
  DateTime? callStartedAt;
  DateTime? tokenExpiresAt;
  Duration elapsed = Duration.zero;
  Timer? _timer;

  // ===== Logs
  final List<CallLogEntry> recentCalls = [];

  // ===== Init / Lifecycle
  Future<void> initScreen() async {
    // Outbound Nummern laden (falls verfügbar)
    try {
      final list = await callRepo.fetchOutboundNumbers();
      if (list.isNotEmpty) {
        fromNumbers = list;
        if (!fromNumbers.contains(selectedFromNumber)) {
          selectedFromNumber = list.first;
        }
      }
    } catch (_) {
      // still ok – fallback bleibt "Company default"
    }

    // Token-Ablauf (optional)
    try {
      tokenExpiresAt = await voice.getTokenExpiry();
    } catch (_) {}

    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneCtrl.dispose();
    noteCtrl.dispose();
    phoneFocus.dispose();
    super.onClose();
  }

  // ===== Helpers
  /// Entfernt alles außer Ziffern und ein führendes '+'.
  String get normalizedTo {
    final raw = phoneCtrl.text.trim();
    if (raw.isEmpty) return '';
    // Erlaube führendes '+' (E.164), entferne sonst Nicht-Ziffern
    final cleaned = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    // Wenn '+' irgendwo mittendrin, behalten wir nur das erste Zeichen falls am Anfang
    if (cleaned.startsWith('+')) {
      return '+${cleaned.substring(1).replaceAll(RegExp(r'[^0-9]'), '')}';
    }
    return cleaned.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String get formattedElapsed {
    final mm = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = elapsed.inHours;
    return hh > 0 ? '$hh:$mm:$ss' : '$mm:$ss';
  }

  void onPhoneChanged(String _) => update();

  void setFromNumber(String value) {
    selectedFromNumber = value;
    update();
  }

  void toggleAutoNumbering(bool v) {
    autoNumberingEnabled = v;
    update();
  }

  // ===== Call flow
  Future<void> startCall(String toNumber) async {
    final number = (toNumber.isNotEmpty ? toNumber : phoneCtrl.text).trim();
    if (number.isEmpty) {
      Get.snackbar('Number required', 'Please enter a phone number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // UI → Connecting
    isCalling = true;
    inCall = false;
    callState = CallState.connecting;
    statusLabel = 'Dialing…';
    callStartedAt = null;
    elapsed = Duration.zero;
    _stopTicker();
    update();

    try {
      final from = autoNumberingEnabled ? null : selectedFromNumber;
      final id = await voice.startCall(
        to: normalizedTo,
        from: from,
        note: noteCtrl.text.trim(),
        autoNumber: autoNumberingEnabled,
      );
      currentCallId = id;

      // UI → Connected
      isCalling = false;
      inCall = true;
      callState = CallState.connected;
      statusLabel = 'Connected';
      callStartedAt = DateTime.now();
      _startTicker();
      update();
    } catch (e) {
      isCalling = false;
      inCall = false;
      callState = CallState.failed;
      statusLabel = 'Failed';
      _logCall(outcome: 'Failed');
      update();
      // Optional Snackbar, aber ohne Spam:
      Get.snackbar('Call failed', 'Could not start the call',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> endCall() async {
    try { await voice.endCall(); } catch (_) {}
    _stopTicker();

    // Dauer berechnen
    final endedAt = DateTime.now();
    final dur = callStartedAt == null ? Duration.zero : endedAt.difference(callStartedAt!);

    _logCall(outcome: 'Ended', overrideDuration: dur, overrideStartedAt: callStartedAt ?? endedAt);

    // Reset State
    isCalling = false;
    inCall = false;
    callState = CallState.ended;
    statusLabel = 'Idle';
    _muted = false;
    _speakerOn = false;
    _recordingEnabled = false;
    callStartedAt = null;
    elapsed = Duration.zero;
    update();
  }

  // Kompatibilität für alten Dialer
  Future<void> hangup() async => endCall();

  // ===== Quick actions
  void toggleMute() {
    _muted = !_muted;
    try { voice.mute(_muted); } catch (_) {}
    update();
  }

  void toggleSpeaker() {
    _speakerOn = !_speakerOn;
    try { voice.speaker(_speakerOn); } catch (_) {}
    update();
  }

  void toggleRecording() {
    _recordingEnabled = !_recordingEnabled;
    try { voice.record(_recordingEnabled); } catch (_) {}
    update();
  }

  void redial(CallLogEntry log) {
    phoneCtrl.text = log.toNumber;
    update();
    startCall(log.toNumber);
  }

  // ===== Optional: Message Hook für den Screen (Bottom Sheet)
  /// Hook für spätere SMS/Chat-Integration – aktuell nur Platzhalter.
  /// Binde hier z. B. Twilio Programmable SMS ein.
  Future<void> sendMessage(String to, String message) async {
    // Beispiel:
    // await callRepo.sendSms(to: to, text: message);
    // Für jetzt nur UI-Feedback:
    Get.snackbar('Message', 'Message queued to $to',
        snackPosition: SnackPosition.BOTTOM);
  }

  // ===== Externe Status-Integration (optional)
  /// Falls dein TwilioVoiceService Events liefert (ringing, reconnecting, etc.),
  /// kannst du von dort diese Methode aufrufen, um das UI sauber zu aktualisieren.
  void applyExternalState(CallState state, {String? label, String? callId}) {
    callState = state;
    statusLabel = label ?? _defaultLabelFor(state);

    if (state == CallState.connected) {
      isCalling = false;
      inCall = true;
      callStartedAt ??= DateTime.now();
      _startTicker();
    } else if (state == CallState.connecting || state == CallState.ringing || state == CallState.reconnecting) {
      isCalling = true;
      inCall = false;
    } else if (state == CallState.failed) {
      isCalling = false;
      inCall = false;
      _stopTicker();
      _logCall(outcome: 'Failed');
    } else if (state == CallState.ended) {
      isCalling = false;
      inCall = false;
      _stopTicker();
      _logCall(outcome: 'Ended');
    }

    if (callId != null) currentCallId = callId;
    update();
  }

  String _defaultLabelFor(CallState s) {
    switch (s) {
      case CallState.idle: return 'Idle';
      case CallState.connecting: return 'Dialing…';
      case CallState.ringing: return 'Ringing…';
      case CallState.connected: return 'Connected';
      case CallState.reconnecting: return 'Reconnecting…';
      case CallState.failed: return 'Failed';
      case CallState.ended: return 'Ended';
    }
  }

  // ===== Timer
  void _startTicker() {
    _timer?.cancel();
    // falls bereits eine Zeit lief, übernehmen – sonst von 0
    if (callStartedAt == null) callStartedAt = DateTime.now();
    elapsed = DateTime.now().difference(callStartedAt!);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (callStartedAt != null) {
        elapsed = DateTime.now().difference(callStartedAt!);
        update();
      }
    });
  }

  void _stopTicker() {
    _timer?.cancel();
    _timer = null;
  }

  // ===== Logging
  void _logCall({
    required String outcome,
    DateTime? overrideStartedAt,
    Duration? overrideDuration,
  }) {
    final started = overrideStartedAt ?? callStartedAt ?? DateTime.now();
    final dur = overrideDuration ??
        (callStartedAt == null ? Duration.zero : DateTime.now().difference(callStartedAt!));

    final to = normalizedTo.isNotEmpty ? normalizedTo : phoneCtrl.text.trim();
    final from = selectedFromNumber;

    // Leeren Eintrag vermeiden, wenn gar keine Nummer vorhanden
    if (to.isEmpty && from.isEmpty) return;

    recentCalls.insert(
      0,
      CallLogEntry(
        toNumber: to,
        fromNumber: from,
        startedAt: started,
        duration: dur,
        outcome: outcome,
        callId: currentCallId,
      ),
    );

    // Liste begrenzen (z. B. Top 50 lokal)
    if (recentCalls.length > 50) {
      recentCalls.removeRange(50, recentCalls.length);
    }
  }
}
