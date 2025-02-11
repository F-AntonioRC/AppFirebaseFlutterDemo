import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

  /// La clase `ThemeNotifier` permite alternar entre un tema claro y oscuro.
  ///
  /// Esta clase extiende de [ChangeNotifier] para que los widgets que dependan del tema
  /// puedan actualizarse automáticamente cuando se realice un cambio.

class ThemeNotifier extends ChangeNotifier {
  // Variable privada que almacena el estado actual del tema: `true` para tema oscuro y `false` para tema claro.
  bool _isDarkTheme = false;

  // Retorna `true` si el tema actual es oscuro, o `false` si es claro.
  bool get isDarkTheme => _isDarkTheme;

  // Alterna el tema actual entre oscuro y claro, y notifica a los listeners.
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
  // Retorna el [ThemeData] actual en función del estado de [_isDarkTheme].
  ThemeData get currentTheme => _isDarkTheme ? darkTheme : lightTheme;
  }

  /// Definición del tema oscuro de la aplicación.
  ///
  /// Se configuran colores, estilos de textos, temas para el AppBar, Drawer e InputDecoration.

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: dark, // Color de la card
  hintColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.white), // Color de los iconos
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black)
  ),
  scaffoldBackgroundColor: darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: light,
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
  hintStyle: TextStyle(color: Colors.white), // Estilo del texto de sugerencia
  labelStyle: TextStyle(color: Colors.white),
)
);

  /// Definición del tema claro de la aplicación.
  ///
  /// Se configuran colores, estilos de textos, temas para el AppBar, Drawer e InputDecoration.

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
    cardColor: light, // Color de la card
    hintColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.black), // Color de los iconos
    textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black)
    ),
  scaffoldBackgroundColor: lightBackground,
  colorScheme: const ColorScheme.light(
      surface: light,
      primary: darkBackground,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: light
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: light
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