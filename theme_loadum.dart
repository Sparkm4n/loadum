import 'package:flutter/material.dart';

class LoadumBrand {
  static const primary = Color(0xFF3873C2);
  static const accent  = Color(0xFF6ECFE1);
  static const surface = Color(0xFFF7FAFF);
}

ThemeData buildLoadumTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: LoadumBrand.primary,
    brightness: brightness,
    primary: LoadumBrand.primary,
    secondary: LoadumBrand.accent,
    surface: isDark ? const Color(0xFF0F172A) : LoadumBrand.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: scheme.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.white,
      ),
    ),

    // <-- HIER: CardThemeData statt CardTheme
    cardTheme: CardThemeData(
      color: isDark ? const Color(0xFF111827) : Colors.white,
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: scheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outline.withOpacity(.12),
      thickness: 1,
      space: 1,
    ),

    // In ganz neuen Flutter-Versionen ist WidgetStateProperty korrekt.
    // Falls dein SDK meckert, ersetze WidgetStateProperty.* durch MaterialStateProperty.*.
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
            ? scheme.primary
            : scheme.outline,
      ),
      trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
            ? scheme.primary.withOpacity(.35)
            : scheme.outlineVariant.withOpacity(.2),
      ),
    ),

    textTheme: Typography.blackMountainView.apply(
      bodyColor: isDark ? Colors.white : const Color(0xFF0F172A),
      displayColor: isDark ? Colors.white : const Color(0xFF0F172A),
    ),
  );
}
