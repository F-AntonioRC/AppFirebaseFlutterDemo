import 'package:flutter/material.dart';
import '../../util/responsive.dart';

/// La clase `BuildField` es un StatelessWidget en dart que recibe como parametros:
/// title tipo String, controller tipo TextEditingController, y theme tipo ThemeData.
class BuildField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final ThemeData theme;

  const BuildField({super.key,
    required this.title,
    required this.controller,
    required this.theme});

/// Esta función de Dart crea una columna con un texto de título y un campo de texto de 
/// solo lectura con un estilo específico.
/// 
/// Devuelve:
/// Se devuelve un widget Column, que contiene un widget Text que muestra un título con un estilo
/// especificado, seguido de un widget SizedBox con una altura de 10.0 y un widget TextField con 
/// propiedades de decoración específicas como readOnly, controller y InputDecoration con 
/// prefixIcon, enabledBorder, focusBorder y disabledBorder.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: responsiveFontSize(context, 15),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        TextField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.hintColor),
                borderRadius: BorderRadius.circular(10.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.hintColor),
                borderRadius: BorderRadius.circular(10.0)),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
