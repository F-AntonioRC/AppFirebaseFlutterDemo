import 'package:flutter/material.dart';
/// La clase `BodyWidgets` es un StatelessWidget en dart que recibe como parametro:
/// body tipo Widget
class BodyWidgets extends StatelessWidget {
  final Widget body;

  const BodyWidgets({super.key, required this.body});

/// La función de compilación devuelve un widget Contenedor con un elemento secundario Card 
/// que contiene un widget de cuerpo con un padding especifico.
/// Devuelve:
/// Un widget Contenedor con un elemento secundario Tarjeta que contiene un widget 
/// padding con un elemento secundario llamado Cuerpo.
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(15.0),
        child: body,
        ),
      ),
    );
  }
}
