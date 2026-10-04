import 'package:flutter/material.dart';

class AppTheme {
  static const Color blue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color background = Color(0xFFF7FAFF);
  static const Color darkText = Color(0xFF172033);

  static ThemeData theme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: false,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: blue,
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: blue,
          width: 1.5,
        ),
      ),
    ),
  );
}