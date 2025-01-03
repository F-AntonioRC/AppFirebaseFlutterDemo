import 'package:flutter/cupertino.dart';

class CircleColor extends StatelessWidget {
  final Color circleColor;

  const CircleColor({super.key, required this.circleColor});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho y la altura de la pantalla
    double screenSize= MediaQuery.of(context).size.width;

    // Definir el tamaño del círculo como un porcentaje de la pantalla
    double circleSize = screenSize < 600 ? screenSize * 0.05 : screenSize * 0.02; // Por ejemplo, 15% del ancho de la pantalla

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        color: circleColor,
        shape: BoxShape.circle
      ),
    );
  }
}
