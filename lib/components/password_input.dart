import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String hindText;
  final bool messageadd;

  const PasswordInput(
      {super.key,
      required this.controller,
      required this.hindText,
      required this.messageadd});

  @override
  Widget build(BuildContext context) {
    return PasswordField(
      color: Colors.blue,
      hintText: hindText,
      controller: controller,
      border: PasswordBorder(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade900),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 2, color: Colors.grey.shade500),
        ),
      ),
      errorMessage: messageadd
          ? "Por favor ingrese la contraseña"
          : "Recomendacion de contraseña: "
          "\n- Letras Mayusculas y minusculas 8 caracteres "
          "\n- Combine con numeros y simbolos",
    );
  }
}
