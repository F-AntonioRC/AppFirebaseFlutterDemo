import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

  /// La clase `HeaderGraphics` es un StatelessWidget que recibe parametros para mostrar la grafica
  /// de linea, alternando segun el valor del `viewOtherGraphics`.
class HeaderGraphics extends StatelessWidget {
  final String title; // Titulo del grafico, cambiara segun el valor de `viewOtherGraphics`.
  final VoidCallback onToggleView; // Función para cambiar los valores de la busqueda.
  final bool viewOtherGraphics; // Valor para alternar los datos del grafico.
  final String viewOn; // Valor para mostrar segun el valor del `viewOtherGraphics`.
  final String viewOff; // Valor para mostrar segun el valor del `viewOtherGraphics`.

  const HeaderGraphics(
      {super.key,
      required this.title,
      required this.onToggleView,
      required this.viewOtherGraphics,
      required this.viewOn,
      required this.viewOff});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 4,
            //Widget para mostrar el valor del `title`.
            child: Text(
              title,
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold),
            )),
        Expanded(
            flex: 2,
            //Widget para alternar el valor de la grafica con los pametros establecidos.
            child: Ink(
              decoration: const ShapeDecoration(
                  shape: CircleBorder(), color: lightBackground),
              child: IconButton(
                onPressed: onToggleView,
                tooltip: viewOtherGraphics ? viewOff : viewOn,
                icon: Icon(viewOtherGraphics
                    ? Icons.change_circle_outlined
                    : Icons.change_circle_outlined),
              ),
            ))
      ],
    );
  }
}
