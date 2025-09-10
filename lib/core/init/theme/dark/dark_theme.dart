import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';

class ProjectTheme {
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: ProjectColors.haiti,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ProjectColors.haiti,
    appBarTheme: AppBarTheme(
      backgroundColor: ProjectColors.haitiDark,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(
        color: ProjectColors.white,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: ProjectColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    dividerColor: ProjectColors.borderColor,
  );
}
