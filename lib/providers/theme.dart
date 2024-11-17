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
    secondary: dark
  ),
    drawerTheme: const DrawerThemeData(
    backgroundColor: dark
),
  appBarTheme: const AppBarTheme(
    backgroundColor: dark
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  canvasColor: dark,
  iconTheme: const IconThemeData(color: Colors.black),
  focusColor: dark,
  cardColor: ligth,
  scaffoldBackgroundColor: ligthBackground,
  colorScheme: const ColorScheme.light(
      surface: ligth,
      primary: darkBackground,
      onPrimary: dark,
      onSecondary: dark,
      tertiary: dark
  ),
  textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black)
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: ligth
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: ligth
  ),
);