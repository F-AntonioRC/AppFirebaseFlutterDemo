import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/providers/theme.dart';

import '../util/responsive.dart';

class ThemeColor extends StatelessWidget {
  const ThemeColor({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return BodyWidgets(body: SingleChildScrollView(child:
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Modo oscuro ",
          style: TextStyle(
            fontSize: responsiveFontSize(context, 22),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(width: 5.0),
        const Icon(Icons.sunny),
        const SizedBox(width: 5.0),
        Switch(
          value: themeNotifier.isDarkTheme,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
        const SizedBox(width: 10.0),
        const Icon(Icons.dark_mode),
      ],
    ),));
  }
}

