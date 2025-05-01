import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: oliveGreen,
      scaffoldBackgroundColor: white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: charcoal),
        bodyMedium: TextStyle(color: grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oliveGreen,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: oliveGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: charcoal),
        hintStyle: TextStyle(color: grey.withOpacity(0.6)),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color charcoal = Color(0xFF263238);
  static const Color grey = Color(0xFF757575);
  static const Color white = Colors.white;
  static const Color oliveGreen = Color(0xFF4CAF50);
  static const Color glassWhite = Color(0x22FFFFFF);
  static const Color cardBackgroundLight = Color(0xFFF5F5F5);
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
}