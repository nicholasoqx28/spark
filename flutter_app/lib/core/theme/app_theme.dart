import 'package:flutter/material.dart';

class AppTheme {
  static const _indigo = Color(0xFF4F46E5);
  static const _indigoDark = Color(0xFF4338CA);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _indigo,
          primary: _indigo,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111827),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _indigo,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _indigo,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          color: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      );

  static const primaryColor = _indigo;
  static const primaryDark = _indigoDark;
}

// Badge colour helpers
Color statusColor(String status) => switch (status) {
      'UPCOMING' => const Color(0xFF3B82F6),
      'ONGOING' => const Color(0xFF10B981),
      'COMPLETED' => const Color(0xFF6B7280),
      _ => const Color(0xFFEF4444),
    };

Color levelColor(String level) => switch (level) {
      'BEGINNER' => const Color(0xFF10B981),
      'INTERMEDIATE' => const Color(0xFFF59E0B),
      _ => const Color(0xFFEF4444),
    };
