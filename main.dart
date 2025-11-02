// lib/main.dart
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, BindingBase;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

// Projekt
import 'package:flutex_admin/core/service/notification_service.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'core/service/di_services.dart' as services;
import 'package:flutex_admin/common/controllers/theme_controller.dart';
import 'package:flutex_admin/common/controllers/localization_controller.dart';
import 'package:flutex_admin/core/utils/themes.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/features/call/repo/call_repo.dart';
import 'package:flutex_admin/features/call/service/twilio_voice_service.dart';
import 'package:flutex_admin/features/call/controller/call_controller.dart';

// Plattform-sichere HttpOverrides (kein direct import von dart:io)
import 'platform_http_overrides.dart';

// ===== Local Notifications (global) =====
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _androidHighChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'High priority notifications.',
  importance: Importance.high,
);

// ===== FCM Background-Handler (top-level) =====
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    fcm.RemoteMessage message,
    ) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Optional: Logging/Handling
}

Future<void> main() async {
  // Eine Zone, kein runZonedGuarded => kein Zone-Mismatch auf Web.
  WidgetsFlutterBinding.ensureInitialized();

  // Fehler-Logging (hilft beim Aufspüren von RangeError + Stacktrace)
  BindingBase.debugZoneErrorsAreFatal = true;
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('🔥 FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) debugPrint(details.stack.toString());
  };
  ui.PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🔥 Uncaught platform error: $error');
    debugPrint(stack.toString());
    return true;
  };

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Unterstützt diese Plattform FCM?
  final bool fcmSupported = kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  // Notifications initialisieren (auf Web bewusst ohne flutter_local_notifications)
  String? typeID;
  if (fcmSupported) {
    await _initNotificationsCrossPlatform();
    typeID = await _getInitialTypeId();
  } else {
    await _initLocalNotificationsOnly(); // Windows/Linux: nur lokal
  }

  // SharedPreferences in GetX
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut<SharedPreferences>(() => sharedPreferences, fenix: true);

  // DI/Services (registriert u.a. Theme/Localization Controller)
  final Map<String, Map<String, String>> languages = await services.init();

  // (Dev) SSL umgehen (no-op auf Web)
  enableInsecureHttp();

  runApp(MyApp(typeID: typeID, languages: languages));
}

// ----- Initialisierung: Lokale Benachrichtigungen + FCM (plattformbewusst) -----
Future<void> _initNotificationsCrossPlatform() async {
  // ⚠️ Auf WEB KEINE lokalen Notifs initialisieren (Plugin ist dort nicht verfügbar)
  if (!kIsWeb) {
    await _initLocalNotificationsOnly();

    // Android 13+ Runtime-Permission
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImpl = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.createNotificationChannel(_androidHighChannel);
    }

    // Apple (iOS + macOS): Berechtigungen & Foreground-Präsentation
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await fcm.FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);
      await fcm.FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Background-Handler (nur Nicht-Web)
    fcm.FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    // Dein NotificationService (nutzt flutter_local_notifications)
    await NotificationService.initialize(flutterLocalNotificationsPlugin);
  } else {
    // WEB: FCM separat (Service Worker) – keine lokalen Notifications anfassen.
    debugPrint('ℹ️ Web: Überspringe lokale Notifications/Permissions.');
  }
}

Future<void> _initLocalNotificationsOnly() async {
  // Wird nur auf Nicht-Web aufgerufen
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const darwinInit = DarwinInitializationSettings(); // iOS/macOS
  const linuxInit = LinuxInitializationSettings(defaultActionName: 'Open');
  const windowsInit = WindowsInitializationSettings(
    appName: '',
    appUserModelId: '',
    guid: '',
  );

  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: darwinInit,
    macOS: darwinInit,
    linux: linuxInit,
    windows: windowsInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<String?> _getInitialTypeId() async {
  try {
    // Auf Web liefert das oft null; safe casten.
    final initial = await fcm.FirebaseMessaging.instance.getInitialMessage();
    final data = initial?.data;
    if (data == null || data.isEmpty) return null;
    final dynamic v = data['typeID'];
    return v is String ? v : v?.toString();
  } catch (e, st) {
    debugPrint('⚠️ getInitialTypeId() error: $e\n$st');
    return null;
  }
}

// ===== App-Widget =====
class MyApp extends StatelessWidget {
  final String? typeID;
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.typeID, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (locController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,

          // Routing
          initialRoute: RouteHelper.splashScreen,
          getPages: RouteHelper().routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),

          // Titel & i18n
          title: LocalStrings.appName.tr,
          translations: Messages(languages: languages),
          locale: locController.locale,
          fallbackLocale: const Locale('en', 'US'),

          // Themes
          theme: themeController.darkTheme ? dark : light,

          // DI-Bindings
          initialBinding: _AppBindings(),
        );
      });
    });
  }
}

// ===== Zentrale DI (GetX) =====
class _AppBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<TwilioVoiceService>()) {
      Get.put(TwilioVoiceService(), permanent: true);
    }
    if (!Get.isRegistered<CallRepo>()) {
      Get.put(CallRepo(apiClient: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<CallController>()) {
      Get.put(
        CallController(
          callRepo: Get.find<CallRepo>(),
          voice: Get.find<TwilioVoiceService>(),
        ),
        permanent: true,
      );
    }
  }
}
