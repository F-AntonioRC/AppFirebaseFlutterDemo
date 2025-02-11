import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/providers/theme.dart';

import '../../util/responsive.dart';

  /// La clase `ThemeColor` es un StatelessWidget que maneja el tema de la UI mediante el uso de
  /// un provider establecido para cambiarlo.
class ThemeColor extends StatelessWidget {
  const ThemeColor({super.key});

  @override
  Widget build(BuildContext context) {
    // Se declara el valor para leer el ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return BodyWidgets(body: SingleChildScrollView(child:
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Modo oscuro",
          style: TextStyle(
            fontSize: responsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(width: 5.0),
        // Icono predeterminado del tema [Modo claro]
        const Icon(Icons.sunny, size: 25),
        const SizedBox(width: 5.0),
        // Switch que llama al Provider para cambiar los colores del tema al modo oscuro
        Switch(
          value: themeNotifier.isDarkTheme,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
        const SizedBox(width: 5.0),
        // Icono del modo oscuro
        const Icon(Icons.dark_mode, size: 25),
      ],
    ),));
  }
}

