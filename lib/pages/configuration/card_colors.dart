import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/circle_color.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class CardColors extends StatefulWidget {
  const CardColors({super.key});

  @override
  State<CardColors> createState() => _CardColorsState();
}

class _CardColorsState extends State<CardColors> {
  @override
  Widget build(BuildContext context) {
    return const BodyWidgets(body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Colores del tema",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0),
        CircleColor(circleColor: darkBackground),
        SizedBox(width: 10),
        CircleColor(circleColor: dark),
        SizedBox(width: 10),
        CircleColor(circleColor: greenColor),
        SizedBox(width: 10),
        CircleColor(circleColor: ligthBackground),
        SizedBox(width: 10),
        CircleColor(circleColor: ligth)
      ],
    ));
  }
}
