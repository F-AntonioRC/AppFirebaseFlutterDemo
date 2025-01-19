import 'package:flutter/cupertino.dart';
import '../../components/firebase_reusable/firebase_dropdown.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';

class FormBodyDetailCourses extends StatelessWidget {
  final FirebaseDropdownController controllerCourse;
  final FirebaseDropdownController controllerSare;
  final FirebaseDropdownController controllerArea;
  final String title;

  const FormBodyDetailCourses({super.key,
    required this.controllerCourse,
    required this.controllerSare,
    required this.controllerArea,
    required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style:
          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
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
                    controller: controllerArea,
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
