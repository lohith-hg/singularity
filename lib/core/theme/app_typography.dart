import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  // Display — Newsreader serif
  static TextStyle get display1 => GoogleFonts.newsreader(
    fontSize: 56,
    height: 1.02,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.bone,
  );

  static TextStyle get display2 => GoogleFonts.newsreader(
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.bone,
  );

  static TextStyle get display3 => GoogleFonts.newsreader(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.bone,
  );

  // UI — Geist sans
  static const TextStyle title = TextStyle(
    fontFamily: 'Geist',
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.bone,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Geist',
    fontSize: 15,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: AppColors.bone2,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Geist',
    fontSize: 13,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.bone2,
  );

  // Data — JetBrains Mono
  static TextStyle get caption => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    height: 1.4,
    fontWeight: FontWeight.w300,
    color: AppColors.bone3,
  );

  static TextStyle get eyebrow =>
      GoogleFonts.jetBrainsMono(
        fontSize: 10,
        height: 1.3,
        fontWeight: FontWeight.w400,
        color: AppColors.bone3,
        letterSpacing: 1.6,
      ).copyWith(
        // uppercase applied at widget level via TextTransform or explicit
      );
}
