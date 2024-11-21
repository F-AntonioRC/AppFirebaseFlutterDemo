import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkTheme ? darkTheme : lightTheme;
  }

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: dark,
  hintColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white)
  ),
  scaffoldBackgroundColor: darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: ligth,
    surface: dark,
  ),
    drawerTheme: const DrawerThemeData(
    backgroundColor: dark
),
  appBarTheme: const AppBarTheme(
    backgroundColor: dark
  ),
inputDecorationTheme: const InputDecorationTheme(
  filled: true,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white)
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
  ),
  hintStyle: const TextStyle(color: Colors.white), // Estilo del texto de sugerencia
  labelStyle: const TextStyle(color: Colors.white),
)
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
    cardColor: ligth,
    hintColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black)
    ),
  scaffoldBackgroundColor: ligthBackground,
  colorScheme: const ColorScheme.light(
      surface: ligth,
      primary: darkBackground,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: ligth
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: ligth
  ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade900)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade900)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade900)
      ),
      hintStyle: const TextStyle(color: Colors.black), // Estilo del texto de sugerencia
      labelStyle: const TextStyle(color: Colors.black),
    )
);