import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';

class ThemeColor extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const ThemeColor({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Activar/Desactivar modo oscuro",
              style: TextStyle(fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10.0),
            const Icon(Icons.sunny),
            Switch(
              value: isDarkMode, // Estado actual del Switch
              onChanged: toggleTheme, // Cambiar el tema cuando el usuario interactúe
            ),
            const Icon(Icons.dark_mode),
          ],
        ),
      ),
    );
  }
}
