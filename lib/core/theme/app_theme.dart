import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.ink,
    fontFamily: 'Geist',
    colorScheme: const ColorScheme.dark(
      surface: AppColors.ink,
      onSurface: AppColors.bone,
      primary: AppColors.bone,
      onPrimary: AppColors.ink,
      secondary: AppColors.signal,
      onSecondary: AppColors.ink,
      error: AppColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: AppColors.bone),
      titleTextStyle: TextStyle(
        fontFamily: 'Geist',
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: AppColors.bone,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.hairline,
      thickness: 1,
      space: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.bone,
      selectionColor: Color(0x33F4F2EE),
      selectionHandleColor: AppColors.bone,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.bone;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.ink),
      side: const BorderSide(color: AppColors.bone3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.ink;
        return AppColors.bone3;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.bone;
        return AppColors.ink3;
      }),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.bone,
      inactiveTrackColor: AppColors.ink3,
      thumbColor: AppColors.bone,
      overlayColor: Color(0x1AF4F2EE),
      trackHeight: 2,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
