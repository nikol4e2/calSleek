import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryRed = Color(0xFFFF2D55);
  static const Color primaryRedDark = Color(0xFFE0224A);
  static const Color primaryRedLight = Color(0xFFFF5C7A);

  // Background
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF111111);
  static const Color cardBackground = Color(0xFF1C1C1E);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA3A3A3);
  static const Color textTertiary = Color(0xFF6E6E6E);

  // Accent / Status
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFCC00);
  static const Color error = Color(0xFFFF2D55);

  // Progress & Charts
  static const Color progressBackground = Color(0xFF2C2C2E);
  static const Color chartLine = Color(0xFFFF2D55);
  static const Color chartFill = Color(0xFFFF2D55);

  // Macros
  static const Color protein = Color(0xFFFF2D55);
  static const Color carbs = Color(0xFF4A9FFF);
  static const Color fat = Color(0xFFFFB800);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF2D55), Color(0xFFE0224A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGlowGradient = LinearGradient(
    colors: [Color(0xFFFF2D55), Color(0x00FF2D55)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Bottom Navigation
  static const Color bottomNavBackground = Color(0xFF111111);
  static const Color bottomNavSelected = Color(0xFFFF2D55);
  static const Color bottomNavUnselected = Color(0xFF8E8E93);
}