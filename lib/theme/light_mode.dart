import 'package:flutter/material.dart';

//colors
// Colores personalizados
Color background = const Color(0xFFFFFFFF);
Color highLight = const Color(0xFFB8261B);
Color text = const Color(0xFF333333);
Color subtitle = const Color(0xA6333333);
Color subtext = const Color(0xFF616161);
Color container = const Color(0xFFF5F5F5);

//Theme
ThemeData lightMode = ThemeData(
  fontFamily: 'Manrope',
  brightness: Brightness.light,
  scaffoldBackgroundColor: background,
  primaryColor: highLight,
  colorScheme: ColorScheme.light(
      surfaceContainer: container,
      secondaryContainer: subtext,
      surface: background,
      primary: highLight,
      onPrimary: Colors.white,
      secondary: text,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      onSurface: subtitle,
      tertiary: subtext),
);
