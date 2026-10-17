import 'package:flutter/material.dart';

class AppColors {
  // Base dark palette (Obsidian athletic aesthetic)
  static const Color darkBackground = Color(0xFF0D0F14);
  static const Color darkSurface = Color(0xFF151922);
  static const Color darkSurfaceLight = Color(0xFF1F2432);
  static const Color darkSurfaceBorder = Color(0xFF282F3F);
  static const Color darkTextPrimary = Color(0xFFF6F8FB);
  static const Color darkTextSecondary = Color(0xFF8E9BAE);
  static const Color darkTextMuted = Color(0xFF5A6678);

  // Base light palette (Daylight clean athletic aesthetic)
  static const Color lightBackground = Color(0xFFF4F6F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLight = Color(0xFFE9EEF5);
  static const Color lightSurfaceBorder = Color(0xFFD3DCE6);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dynamic Theme state (updated by ThemeNotifier)
  static bool isDarkMode = true;
  static Color primary = const Color(0xFFE5FE40); // Default Electric Volt Lime
  static Color primaryDark = const Color(0xFFB8D405);

  // Dynamic accessors based on active theme
  static Color get background => isDarkMode ? darkBackground : lightBackground;
  static Color get surface => isDarkMode ? darkSurface : lightSurface;
  static Color get surfaceLight => isDarkMode ? darkSurfaceLight : lightSurfaceLight;
  static Color get surfaceBorder => isDarkMode ? darkSurfaceBorder : lightSurfaceBorder;

  static Color get textPrimary => isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary => isDarkMode ? darkTextSecondary : lightTextSecondary;
  static Color get textMuted => isDarkMode ? darkTextMuted : lightTextMuted;

  // Fixed Accent & Macro colors (Fitness standard)
  static const Color accentOrange = Color(0xFFFF6D3A);
  static const Color accentBlue = Color(0xFF388AF6);
  static const Color accentPurple = Color(0xFF8B5CF6);

  static const Color protein = Color(0xFFFF5252);
  static const Color carbs = Color(0xFF40C4FF);
  static const Color fat = Color(0xFFFFD740);
  static Color get calories => primary;

  // Status colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF3D71);
}
