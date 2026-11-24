import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E4FA3),
      primary: const Color(0xFF1E4FA3),
      error: const Color(0xFFB3261E),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    cardTheme: const CardThemeData(
      color: Color(0xFFF3F5F9),
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1B1F27),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFF1B1F27),
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Color(0xFF1B1F27),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1B1F27),
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF4A5160),
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        color: Color(0xFF4A5160),
        fontSize: 12,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      constraints: BoxConstraints(minHeight: 56),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFF6B7385)),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 72,
      indicatorColor: Color(0x1F1E4FA3),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
