import 'package:flutter/material.dart';

/// La clase `CustomInputDecoration` proporciona un metodo estático para crear una decoración
/// de entrada personalizada para textfields en la aplicación Flutter.
class CustomInputDecoration {
  static InputDecoration inputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.hintColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.hintColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}