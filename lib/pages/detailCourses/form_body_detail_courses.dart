import 'package:flutter/cupertino.dart';
import '../../components/firebase_dropdown.dart';

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
          controller: controllerCourse,
          collection: "Courses",
          data: "NameCourse",
          textHint: 'Seleccione un curso',
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(child: Column(
              children: [
                const Text('SARE',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    controller: controllerSare,
                    collection: "Sare",
                    data: "sare",
                    textHint: "Seleccione una sare"),
              ],
            ),),
            const SizedBox(width: 20.0),
            Expanded(child: Column(
              children: [
                const Text('Area',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    controller: controllerArea,
                    collection: "Area",
                    data: "NombreArea",
                    textHint: "Seleccione un Area"),
              ],
            ),)
          ],
        ),
      ],
    );
  }
}
