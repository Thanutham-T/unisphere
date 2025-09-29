import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/app_color.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primaryBlue,
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
      brightness: Brightness.light,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primaryBlue,
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
      brightness: Brightness.dark,
    );
  }
}
