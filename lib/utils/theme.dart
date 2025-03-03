import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Ubuntu',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: 'Ubuntu',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Ubuntu',
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.outline,
      titleTextStyle: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}
