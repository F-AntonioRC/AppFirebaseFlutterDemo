import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';

/// Un widget que muestra un mensaje recordatorio dentro de una tarjeta (`Card`).
///
/// Esta tarjeta contiene un icono, un título y un subtítulo con un mensaje
/// informativo sobre el envío de constancias y la revisión del correo.
///
/// ### Características:
/// - Utiliza `ListTile` para estructurar el contenido.
/// - Ajusta dinámicamente el tamaño del texto usando `responsiveFontSize`.
/// - Se envuelve en un `Container` con márgenes para un mejor espaciado.

class CardWelcome extends StatelessWidget {
  // Constructor de la tarjeta de bienvenida.
  const CardWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListTile(
                leading: const Icon(
                  Icons.fact_check_outlined, weight: 10.0, size: 50,),
                title: Text("Recuerda enviar tus constancias a tiempo",
                  style: TextStyle(fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),),
                subtitle: Text("Revisa tu correo también para verificar tus cursos",
                  style: TextStyle(fontSize: responsiveFontSize(context, 17),
                      fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
