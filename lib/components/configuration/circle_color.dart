import 'package:flutter/cupertino.dart';

  /// La clase `CircleColor` es un StatelessWidget que recibe como parametro el valor circleColor
  /// de tipo Color para realizar una vista hacerca de los colores del tema en la UI mediante
  /// la visualizacion de circulos responsivos.
class CircleColor extends StatelessWidget {
  final Color circleColor;

  const CircleColor({super.key, required this.circleColor});

  @override
  Widget build(BuildContext context) {
    // Se obtiene el ancho y la altura de la pantalla
    double screenSize= MediaQuery.of(context).size.width;

    // Se define el tamaño del círculo como un porcentaje de la pantalla
    double circleSize = screenSize < 600 ? screenSize * 0.05 : screenSize * 0.02;

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
