import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

/// La clase `PasswordInput` es un StatelessWidget en dart que recibe como parametros:
/// controller tipo TextEditingController, hindText tipo String, y messageadd tipo bool.
class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String hindText;
  final bool messageadd;

  const PasswordInput(
      {super.key,
      required this.controller,
      required this.hindText,
      required this.messageadd});

/// Devuelve:
/// Se devuelve un widget PasswordField con varias propiedades, como color, hintText,
/// controlador y borde. La propiedad de borde se personaliza con diferentes estilos de 
/// borde para estados normales, enfocados y de error. Además, se proporciona un errorMessage 
/// en función de una condición, ya sea solicitando al usuario que ingrese una contraseña o
/// brindando recomendaciones para crear una contraseña segura.
  @override
  Widget build(BuildContext context) {
    return PasswordField(
      hintText: hindText,
      controller: controller,
      border: PasswordBorder(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 2),
        ),
      ),
      errorMessage: messageadd
          ? "Por favor ingrese la contraseña"
          : "Recomendacion de contraseña: "
          "\n- Letras Mayusculas y minusculas 8 caracteres - Combine con numeros y simbolos",
    );
  }
}
