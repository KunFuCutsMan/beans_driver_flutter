import 'package:flutter/material.dart';

class Temas {
  
  static Color verdeCyan = const Color(0xFF00CC66);
  static Color springGreen = const Color(0x0000FF80);
  static Color amarilloVerde = const Color(0xFFCED45E);
  static Color amarilloVerdeClaro = const Color(0xFFFFFFC0);
  static Color verdeNegruzco = const Color(0xFF30454F);
  static Color azulNegruzco = const Color(0xFF031A23);
  static Color rojo = Colors.red;
  static Color blanco = Colors.white;
  static Color negro = Colors.black;

  static ColorScheme colorSchemeClaro = ColorScheme(
    brightness: Brightness.light,
    primary: Temas.verdeCyan,
    onPrimary: Temas.blanco,
    secondary: Temas.amarilloVerde,
    onSecondary: Temas.negro,
    error: Temas.rojo,
    onError: Temas.negro,
    background: Temas.blanco,
    onBackground: Temas.negro,
    surface: Temas.amarilloVerdeClaro,
    onSurface: Temas.amarilloVerdeClaro,
  );

  static ColorScheme colorSchemeOscuro = ColorScheme(
    brightness: Brightness.dark,
    primary: Temas.verdeCyan,
    onPrimary: Temas.blanco,
    secondary: Temas.amarilloVerde,
    onSecondary: Temas.negro,
    error: Temas.rojo,
    onError: Temas.negro,
    background: Temas.azulNegruzco,
    onBackground: Temas.blanco,
    surface: Temas.amarilloVerdeClaro,
    onSurface: Temas.negro,
  );

  static ThemeData temaClaro = ThemeData(
    colorScheme: colorSchemeClaro,
    scaffoldBackgroundColor: Temas.colorSchemeClaro.background,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Temas.colorSchemeClaro.background,
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Temas.colorSchemeClaro.background,
      selectedItemColor: Temas.colorSchemeClaro.onBackground,
      unselectedItemColor: Temas.verdeNegruzco,
    ),
  );

  static ThemeData temaOscuro = ThemeData(
    colorScheme: Temas.colorSchemeOscuro,
    scaffoldBackgroundColor: Temas.colorSchemeOscuro.background,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Temas.colorSchemeOscuro.background,
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Temas.colorSchemeOscuro.background,
      selectedItemColor: Temas.colorSchemeOscuro.onBackground,
      unselectedItemColor: Temas.amarilloVerde,
    ),
  );
}
