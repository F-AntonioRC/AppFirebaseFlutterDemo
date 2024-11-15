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
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white)
  ),
  scaffoldBackgroundColor: darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: darkBackground,
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
  iconTheme: const IconThemeData(color: Colors.black),
  cardColor: ligth,
  scaffoldBackgroundColor: ligthBackground,
  colorScheme: const ColorScheme.light(
      surface: ligth, primary: ligth),
  appBarTheme: const AppBarTheme(
      backgroundColor: ligth
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: ligth
  ),
);