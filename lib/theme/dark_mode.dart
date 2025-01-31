import 'package:flutter/material.dart';

// Colores personalizados
Color background = const Color(0xFF212020);
Color highLight = const Color(0xFFB8261B);
Color text = const Color(0xFFFFFFFF);
Color subtitle = const Color.fromRGBO(255, 255, 255, 0.65);
Color subtext = const Color(0xFF616161);

// Tema oscuro
ThemeData netflix = ThemeData(
  fontFamily: 'Manrope',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: background,
  primaryColor: highLight,
  colorScheme: ColorScheme.dark(
    surface: background, // Fondo de tarjetas o diálogos
    primary: highLight, // Color de énfasis principal
    onPrimary: Colors.white, // Texto o íconos sobre 'primary'
    secondary: text, // Color secundario
    onSecondary: Colors.black, // Texto o íconos sobre 'secondary'
    error: Colors.red, // Color para errores
    onError: Colors.white, // Texto sobre fondo principal
    onSurface: subtitle, // Texto sobre superficie
  ),
);
