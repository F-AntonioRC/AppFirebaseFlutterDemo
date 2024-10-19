import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/courses.dart';

class ScreenCursos extends StatefulWidget {
  const ScreenCursos({super.key});

  @override
  State<ScreenCursos> createState() => _ScreenCursosState();
}

class _ScreenCursosState extends State<ScreenCursos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Courses(),
        ),
        Expanded( child:
          Container(
            color: Colors.blueAccent, // Ejemplo de otro componente
            child: const Center(child: Text('Otro Componente')),
          ),
        ),
      ],
    );
  }
}
