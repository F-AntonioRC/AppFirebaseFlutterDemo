import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/circle_color.dart';
import 'package:testwithfirebase/components/theme_color.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class CardColors extends StatefulWidget {
  const CardColors({super.key});

  @override
  State<CardColors> createState() => _CardColorsState();
}

class _CardColorsState extends State<CardColors> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Card(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Colores del tema", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
    SizedBox(width: 20.0),
    CircleColor(circleColor: darkBackground),
    SizedBox(width: 20),
    CircleColor(circleColor: dark),
    SizedBox(width: 20),
    CircleColor(circleColor: greenColor),
    SizedBox(width: 20),
    CircleColor(circleColor: ligthBackground),
    SizedBox(width: 20),
    CircleColor(circleColor: ligth)
    ],
    ),
    )
    );
  }
}
