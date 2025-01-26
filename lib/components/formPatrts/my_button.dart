import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';

/// La clase `MyButton` es un StatelessWidget en dart que recibe como parametros:
/// text tipo String, icon tipo Icon, onPressed tipo Function y buttonColor tipo Color.
class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon icon;
  final Color buttonColor;

  const MyButton(
      {super.key, required this.text, this.onPressed, required this.icon, required this.buttonColor});

/// Esta función crea una fila centrada que contiene un botón elevado con un ícono y texto.
  /// 
/// Devuelve:
/// Se devuelve un widget `Row` que contiene un widget `ElevatedButton.icon` con las propiedades y 
/// el estilo especificados. El widget `ElevatedButton.icon` incluye un ícono, un texto de etiqueta
///  y una función de devolución de llamada `onPressed`.
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          ),
          onPressed: onPressed,
          icon: icon,
          iconAlignment: IconAlignment.end,
          label: Text(
            text,
            style: TextStyle(fontSize: responsiveFontSize(context, 16), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
