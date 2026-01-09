import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFF6200EA); // Deep Purple
  static const Color secondary = Color(0xFF00E5FF); // Neon Cyan
  static const Color error = Color(0xFFCF6679);
  static const Color onBackground = Colors.white;
  static const Color onSurface = Colors.white70;
}

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColors.onSurface,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Orbitron', // Suggested for Cyberpunk feel (if added later)
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface.withOpacity(0.8),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.primary, width: 1),
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: AppColors.background),
);
