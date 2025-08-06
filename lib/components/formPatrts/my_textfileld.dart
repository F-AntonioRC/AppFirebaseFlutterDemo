import 'package:flutter/material.dart';

/// La clase `MyTextfileld` es un StatefulWidget en dart que recibe como parametros:
/// hindText tipo String, icon tipo Icon, controller tipo TextEditingController, keyboardType tipo TextInputType
/// y validator tipo Function(String?)?.
class MyTextfileld extends StatelessWidget {
  final String hindText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const MyTextfileld(
      {super.key,
      required this.hindText,
      required this.icon,
      required this.controller,
      required this.keyboardType,
      this.validator});

/// Esta función crea un widget TextFormField con decoración y propiedades específicas 
/// en una aplicación Flutter
/// 
/// Devuelve:
/// Se devuelve un widget `TextFormField`. Incluye varias propiedades como `keyboardType`,
/// `controller`, `decoration` y más. La propiedad `decoration` especifica la apariencia del
/// campo de entrada con sugerencias, íconos, bordes y estilos según el tema actual.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          hintText: hindText,
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
