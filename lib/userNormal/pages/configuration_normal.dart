import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/pages/configuration/card_colors.dart';
import 'package:testwithfirebase/pages/configuration/theme_color.dart';

class ConfigurationNormal extends StatelessWidget {
  const ConfigurationNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeColor(),
        CardColors()
      ],
    ),
    );
  }
}
