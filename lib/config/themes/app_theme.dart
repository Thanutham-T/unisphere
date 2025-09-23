import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
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
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      scaffoldBackgroundColor: AppColors.darkBackground,
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
          fontSize: 22,
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
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
