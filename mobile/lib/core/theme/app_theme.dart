import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales institucionales
  static const Color primary = Color(0xFF1B5E20); // Verde institucional
  static const Color primaryDark = Color(0xFF0D3311);
  static const Color accent = Color(0xFF4CAF50);

  // Colores del Semáforo Municipal (RF-08, RF-14)
  static const Color statusGreen = Color(0xFF2E7D32);  // < 10 días (Plazas en buen estado)
  static const Color statusYellow = Color(0xFFF9A825); // 10 a 15 días (Alerta de mantenimiento)
  static const Color statusRed = Color(0xFFC62828);    // > 15 días (Corte urgente requerido)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
