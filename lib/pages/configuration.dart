import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/card_colors.dart';
import 'package:testwithfirebase/components/theme_color.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  bool isDarkMode = false; // Estado inicial del tema

  // Función para cambiar el tema
  void toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        color: ligth,
        child: Padding(padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ThemeColor(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              const SizedBox(height: 20.0),
              const CardColors()
            ],
          ),
        ),),
      ),
    );
  }
}
