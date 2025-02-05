import 'package:flutter/material.dart';

  /// El siguiente Widget muestra un indicador compuesto por un color y un texto.
  ///
  /// El widget dibuja un contenedor con un color y forma (cuadrado o circular),
  /// seguido de un texto que lo describe. Es útil para mostrar leyendas en gráficos.

class Indicator extends StatelessWidget {

  /// Constructor del widget.
  ///
  /// [color]: Color del indicador.
  /// [text]: Texto que se mostrará al lado del indicador.
  /// [isSquare]: Si es `true`, el indicador será un cuadrado; si es `false`, será un círculo.
  /// [size]: Tamaño del indicador (ancho y alto). Por defecto es 16.
  /// [textColor]: Color del texto; si no se especifica, se utilizará el color por defecto del tema.

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color; // Color del indicador.
  final String text; // Texto descriptivo del indicador.
  final bool isSquare; // Define si el indicador será cuadrado o circular.
  final double size; // Tamaño (ancho y alto) del indicador.
  final Color? textColor; // Color del texto.

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Contenedor que representa el indicador gráfico.
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            // Si isSquare es verdadero, se usa forma rectangular; de lo contrario, forma circular.
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        // Espacio horizontal entre el indicador y el texto.
        const SizedBox( width: 4),
        // Texto descriptivo del indicador.
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}