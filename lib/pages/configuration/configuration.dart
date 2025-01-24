import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/configuration/card_colors.dart';
import 'package:testwithfirebase/pages/configuration/theme_color.dart';
import 'package:testwithfirebase/pages/configuration/up_file_card.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {



  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeColor(),
        CardColors(),
        UpFileCard()
      ],
    ),);
  }
}
