// lib/core/service/notification_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// Projekt-intern
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';

// Firebase Messaging getrennt als Alias, damit es keine Namenskonflikte gibt
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;

class NotificationService {
  NotificationService._();

  /// ====== Android Channel-Konstanten ======
  static const String _channelId   = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDesc = 'High priority notifications.';

  /// Falls du eine eigene Sound-Ressource (android/app/src/main/res/raw/notification.mp3) hast,
  /// kannst du diese Flag auf true setzen. Ansonsten bleibt es bei Standardsound.
  static const bool _useCustomAndroidSound = false;

  /// Globale Initialisierung: lokale Notifications einrichten, Channel anlegen,
  /// Runtime-Permissions (Android 13+ / iOS), FCM Listener anbinden.
  static Future<void> initialize(FlutterLocalNotificationsPlugin fln) async {
    // --- Init pro Plattform ---
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit  = DarwinInitializationSettings(); // iOS/macOS
    const linuxInit   = LinuxInitializationSettings(defaultActionName: 'Open');

    const init = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
      linux: linuxInit,
    );

    await fln.initialize(
      init,
      onDidReceiveNotificationResponse: (NotificationResponse r) async {
        _handleTapPayload(r.payload);
      },
    );

    // --- Android: Channel & Permission ---
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidImpl = fln.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // Android 13+ Benachrichtigungsrecht
      await androidImpl?.requestNotificationsPermission();

      // Channel anlegen
      final channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      );
      await androidImpl?.createNotificationChannel(channel);
    }

    // --- Apple (iOS/macOS): Berechtigungen & Foreground-Darstellung ---
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await fcm.FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true, provisional: false,
      );
      await fcm.FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true,
      );
    }

    // --- FCM Listener ---
    fcm.FirebaseMessaging.onMessage.listen((fcm.RemoteMessage m) async {
      // Im Vordergrund selbst anzeigen
      await showFromRemoteMessage(m, fln);
    });

    fcm.FirebaseMessaging.onMessageOpenedApp.listen((fcm.RemoteMessage m) async {
      // Beim Tippen auf die System-Notification (App aus Hintergrund)
      _navigateFromData(m.data);
    });
  }

  /// Zeigt eine lokale Notification aus einem [RemoteMessage].
  /// Nutzt BigPicture (falls `image` im payload) oder BigText als Fallback.
  static Future<void> showFromRemoteMessage(
      fcm.RemoteMessage message,
      FlutterLocalNotificationsPlugin fln,
      ) async {
    // Titel/Body bevorzugt aus message.notification, sonst aus data
    final String? title =
        message.notification?.title ?? _asString(message.data['title']);
    final String? body =
        message.notification?.body ?? _asString(message.data['body']);

    final String? image = _asString(message.data['image']);
    final String? type  = _asString(message.data['type']);
    final String? typeId = _asString(message.data['type_id']);

    final Map<String, String?> payload = {
      'title': title,
      'body': body,
      'image': image,
      'type': type,
      'type_id': typeId,
    };

    // Wenn Bild vorhanden und NICHT Web: versuche BigPicture
    if (image != null && image.isNotEmpty && !kIsWeb) {
      try {
        final largeIconPath = await _downloadAndSaveFile(image, 'n_large');
        final bigPicturePath = await _downloadAndSaveFile(image, 'n_big');

        final style = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: title ?? LocalStrings.appName.tr,
          htmlFormatContentTitle: true,
          summaryText: body ?? '',
          htmlFormatSummaryText: true,
        );

        final android = _buildAndroidDetails(
          style: style,
          largeIcon: FilePathAndroidBitmap(largeIconPath),
        );

        await fln.show(
          0,
          title ?? LocalStrings.appName.tr,
          body ?? '',
          NotificationDetails(android: android),
          payload: jsonEncode(_stringify(payload)),
        );
        return;
      } catch (_) {
        // Fallback auf BigText
      }
    }

    // BigText (Default)
    final style = BigTextStyleInformation(
      body ?? '',
      htmlFormatBigText: true,
      contentTitle: title ?? LocalStrings.appName.tr,
      htmlFormatContentTitle: true,
    );

    final android = _buildAndroidDetails(style: style);

    await fln.show(
      0,
      title ?? LocalStrings.appName.tr,
      body ?? '',
      NotificationDetails(android: android),
      payload: jsonEncode(_stringify(payload)),
    );
  }

  /// Baut die AndroidNotificationDetails (ohne copyWith).
  static AndroidNotificationDetails _buildAndroidDetails({
    StyleInformation? style,
    AndroidBitmap<Object>? largeIcon,
  }) {
    // optionaler Custom-Sound
    final AndroidNotificationSound? sound =
    _useCustomAndroidSound ? const RawResourceAndroidNotificationSound('notification') : null;

    return AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: sound,                // nur gesetzt, wenn _useCustomAndroidSound = true
      styleInformation: style,
      largeIcon: largeIcon,
    );
  }

  /// Tap auf Notification (Payload -> Routing)
  static void _handleTapPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final Map<String, dynamic> data = jsonDecode(payload) as Map<String, dynamic>;
      _navigateFromData(data);
    } catch (_) {
      // Ignorieren bei defektem Payload
    }
  }

  /// Zentrales Routing anhand der bekannten Keys (type, type_id)
  static void _navigateFromData(Map data) {
    final String? type = _asString(data['type']);
    final String? typeId = _asString(data['type_id']);
    if (typeId == null || typeId.isEmpty) return;

    try {
      switch (type) {
        case 'invoice':
          Get.toNamed(RouteHelper.invoiceDetailsScreen, arguments: typeId);
          break;
        case 'lead':
          Get.toNamed(RouteHelper.leadDetailsScreen, arguments: typeId);
          break;
        case 'task':
          Get.toNamed(RouteHelper.taskDetailsScreen, arguments: typeId);
          break;
        case 'project':
          Get.toNamed(RouteHelper.projectDetailsScreen, arguments: typeId);
          break;
        case 'proposal':
          Get.toNamed(RouteHelper.proposalDetailsScreen, arguments: typeId);
          break;
        case 'estimate':
          Get.toNamed(RouteHelper.estimateDetailsScreen, arguments: typeId);
          break;
        case 'message':
        // TODO: Nachrichten-Screen öffnen, falls vorhanden
          break;
        default:
        // kein Routing
          break;
      }
    } catch (_) {
      // Navigation-Fehler stillschweigend ignorieren
    }
  }

  /// Lädt ein Bild und speichert es temporär, gibt Dateipfad zurück.
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory dir = await getTemporaryDirectory();
    final String filePath = '${dir.path}/$fileName';
    final dio.Response<List<int>> response = await dio.Dio().get<List<int>>(
      url,
      options: dio.Options(responseType: dio.ResponseType.bytes),
    );
    final File file = File(filePath);
    await file.writeAsBytes(response.data ?? <int>[]);
    return filePath;
  }

  /// Hilfsfunktionen
  static String? _asString(Object? v) => v == null ? null : v.toString();

  static Map<String, String> _stringify(Map<String, String?> src) {
    return src.map((k, v) => MapEntry(k, v ?? ''));
  }
}
