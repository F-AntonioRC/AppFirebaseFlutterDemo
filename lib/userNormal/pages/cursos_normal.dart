import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/card_view_course.dart';

class CursosNormal extends StatelessWidget {
  const CursosNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(child: CardViewCourse(
                  assetImagePath: 'assets/images/logo.jpg',
                  title: "Nombre del curso", subtitle: "Datos del curso"),),
              Expanded(child: CardViewCourse(
                  assetImagePath: 'assets/images/logo.jpg',
                  title: "Nombre del curso", subtitle: "Datos del curso"),),
            ],
          )
        ],
      ),
    );
  }
}
