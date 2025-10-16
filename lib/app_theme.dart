import 'package:flutter/material.dart';

class AppTheme {
  // Colors loosely inspired by Netflix UI clone
  static const Color background = Color(0xFF141414);
  static const Color surface = Color(0xFF1F1F1F);
  static const Color accentRed = Color(0xFFE50914);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);

  static ThemeData get darkTheme {
    // Set Material 3 at construction time (property is deprecated on copyWith)
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: base.colorScheme.copyWith(
        primary: accentRed,
        secondary: accentRed,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface,
        selectedColor: accentRed,
        labelStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}
