import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/userNormal/components/card_graphics_normal.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/card_welcome.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CardWelcome(),
        Expanded(child: SizedBox(height: 300,
        child: CardGraphicsNormal(),
        ))
      ],
    );
  }
}
