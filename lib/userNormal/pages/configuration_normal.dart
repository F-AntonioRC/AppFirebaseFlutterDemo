import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/configuration/card_colors.dart';
import 'package:testwithfirebase/components/configuration/theme_color.dart';
import 'package:testwithfirebase/userNormal/pages/service_apk.dart';

class ConfigurationNormal extends StatelessWidget {
  const ConfigurationNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeColor(),
        CardColors(),
        GetApk(),
      ],
    )
    ); 
  }
}
