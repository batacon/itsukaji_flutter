import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';

final customTheme = ThemeData(
  primarySwatch: _customSwatch,
  colorScheme: const ColorScheme.light(
    primary: CustomColor.primary,
    secondary: CustomColor.primary,
  ),
  textTheme: _customTextTheme,
);

const MaterialColor _customSwatch = MaterialColor(
  0xFF50ABD3,
  <int, Color>{
    50: CustomColor.primary,
    100: CustomColor.primary,
    200: CustomColor.primary,
    300: CustomColor.primary,
    400: CustomColor.primary,
    500: CustomColor.primary,
    600: CustomColor.primary,
    700: CustomColor.primary,
    800: CustomColor.primary,
    900: CustomColor.primary,
  },
);

TextTheme _customTextTheme = const TextTheme(
  displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: CustomColor.text),
  displayMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: CustomColor.text),
  displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: CustomColor.text),
  bodyLarge: TextStyle(fontSize: 18, color: CustomColor.text),
  bodyMedium: TextStyle(fontSize: 16, color: CustomColor.text),
  bodySmall: TextStyle(fontSize: 14, color: CustomColor.text),
  titleSmall: TextStyle(fontSize: 12, decoration: TextDecoration.underline),
);
