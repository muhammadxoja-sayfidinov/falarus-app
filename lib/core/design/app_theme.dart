import 'package:flutter/material.dart';

class AppTheme {
  // Falarus Mint/Teal Palette (from uploaded design)
  static const Color mondeluxPrimary = Color(
    0xFF2D7A6B,
  ); // Medium teal green (for buttons)
  static const Color mondeluxSecondary = Color(0xFF0B5444); // Darker teal green
  static const Color mondeluxAccent = Color(0xFF8FD5C3); // Light mint accent
  static const Color mondeluxBackground = Color(
    0xFFD4E8E3,
  ); // Light mint background
  static const Color mondeluxSurfaceSecond = Color(
    0xFFE8F4F0,
  ); // Very light mint surface

  // Text Colors
  static const Color textPrimary = Color(0xFF1F3D37);
  static const Color textSecondary = Color(0xFF4A6B62);
  static const Color textDisabled = Color(0xFF9DBDB3);

  static ThemeData get mondeluxTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: mondeluxBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mondeluxPrimary,
        primary: mondeluxPrimary,
        secondary: mondeluxSecondary,
        surface: mondeluxBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),

      // App Bar dizayni
      appBarTheme: const AppBarTheme(
        backgroundColor: mondeluxPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Material 3 tintini o'chirish
      ),

      // Tugmalar dizayni
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mondeluxPrimary,
          foregroundColor: Colors.white, // Text color
          disabledBackgroundColor: textDisabled,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mondeluxAccent,
        foregroundColor: mondeluxPrimary,
      ),

      // Card dizayni
      cardTheme: CardThemeData(
        color: mondeluxBackground,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        elevation: 5, // Soya berish uchun
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Kirish maydonlari (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mondeluxSurfaceSecond,
        hintStyle: const TextStyle(color: textDisabled),
        labelStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: mondeluxPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),

      // Matnlar stili
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          // AppBar title
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: mondeluxPrimary),

      // Page Transitions (iOS Style)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
