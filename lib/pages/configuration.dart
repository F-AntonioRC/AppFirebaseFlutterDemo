import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/card_colors.dart';
import 'package:testwithfirebase/pages/theme_color.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {



  @override
  Widget build(BuildContext context) {
    return const Padding(padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeColor(),
        SizedBox(height: 20.0),
        CardColors()
      ],
    ),);
  }
}
