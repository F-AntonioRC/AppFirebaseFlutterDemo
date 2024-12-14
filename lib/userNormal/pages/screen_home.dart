import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/MyDataSource.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/card_welcome.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/table_component_normal.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CardWelcome(),
        Expanded(child:
        TableComponentNormal()
        )
      ],
    );
  }
}
