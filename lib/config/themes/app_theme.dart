import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFF2196F3); // Blue primary color
  static const Color primaryDark = Color(0xFF1976D2);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.white,
        background: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.black,
        onBackground: AppColors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSansThai(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.notoSansThai(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        titleSmall: GoogleFonts.notoSansThai(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        bodyMedium: GoogleFonts.notoSansThai(
          fontSize: 16,
          color: AppColors.black,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.notoSansThai(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.notoSansThai(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansThai(color: Colors.grey),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.darkCard,
        background: AppColors.darkBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSansThai(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.notoSansThai(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        titleSmall: GoogleFonts.notoSansThai(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        bodyMedium: GoogleFonts.notoSansThai(
          fontSize: 16,
          color: AppColors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.notoSansThai(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.notoSansThai(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansThai(color: Colors.grey),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
