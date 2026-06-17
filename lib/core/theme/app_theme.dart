import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBg,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary),
          displayMedium: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBg,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      // Cards
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.borderColor, width: 0.5),
        ),
      ),
      // ElevatedButton → botón primario con gradiente
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      // OutlinedButton → botón ghost
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: AppColors.borderColor, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
      // TextFormField / InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 0.5,
      ),
      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
