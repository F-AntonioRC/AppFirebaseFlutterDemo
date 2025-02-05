import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/configuration/circle_color.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

  /// La clase `CardColors` es un StatefulWidget que muestra la gama de colores del tema actual
  /// mediante el uso del widget personalizado [CircleColor] enviando el color seleccionado en el
  /// archivo [constand].
class CardColors extends StatefulWidget {
  const CardColors({super.key});

  @override
  State<CardColors> createState() => _CardColorsState();
}

class _CardColorsState extends State<CardColors> {
  @override
  Widget build(BuildContext context) {
    return BodyWidgets(body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Colores del tema",
          style: TextStyle(fontSize: responsiveFontSize(context, 22), fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
            children: [
              CircleColor(circleColor: darkBackground),
              SizedBox(height: 5),
              CircleColor(circleColor: dark),
              SizedBox(height: 5),
              CircleColor(circleColor: greenColor),
            ],
            ),
            SizedBox(width: 5.0),
            Column(
              children: [
                CircleColor(circleColor: ligthBackground),
                SizedBox(height: 5),
                CircleColor(circleColor: ligth)
              ],
            )

          ],
        ),
      ],
    ));
  }
}
