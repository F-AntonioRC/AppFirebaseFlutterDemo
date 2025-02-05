import 'package:flutter/cupertino.dart';
import '../../components/firebase_reusable/firebase_dropdown.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';

  /// Estructura del formulario para añadir/editar la asignación de cursos
  ///
  /// Este widget muestra diversos campos de entrada y controladores como [FirebaseDropdownController],
  /// para registrar la información de un curso asignado, como el nombre, sare u Ore,
  /// almacenando los valores capturados para añadir o editar un curso que este asigno.

class FormBodyDetailCourses extends StatelessWidget {
  final FirebaseDropdownController controllerCourse; // Controlador personalizado con la información del curso.
  final FirebaseDropdownController controllerSare; // Controlador personalizado con la información del Sare.
  final FirebaseDropdownController controllerOre; // Controlador personalizado con la información del Ore.
  final String title; // Titulo de la cabecera.

  const FormBodyDetailCourses({super.key,
    required this.controllerCourse,
    required this.controllerSare,
    required this.controllerOre,
    required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del formulario.
        Text(
          title,
          style:
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        // Primera fila: Nombre del curso asignado.
        const Text('Curso',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        FirebaseDropdown(
          enabled: true,
          controller: controllerCourse,
          collection: "Cursos",
          data: "NombreCurso",
          textHint: 'Seleccione un curso',
        ),
        const SizedBox(height: 10.0),
        // Segunda fila: Sare y Ore asignados.
        Row(
          children: [
            Expanded(child: Column(
              children: [
                const Text('ORE',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    enabled: true,
                    controller: controllerOre,
                    collection: "Ore",
                    data: "Ore",
                    textHint: "Seleccione un ORE"),
              ],
            ),),
            const SizedBox(width: 20.0),
            Expanded(child: Column(
              children: [
                const Text('SARE',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                  enabled: true,
                    controller: controllerSare,
                    collection: "Sare",
                    data: "sare",
                    textHint: "Seleccione una sare"),
              ],
            ),),
          ],
        ),
      ],
    );
  }
}
