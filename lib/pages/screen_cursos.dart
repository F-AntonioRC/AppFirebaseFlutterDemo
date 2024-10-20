import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/courses.dart';
import 'package:testwithfirebase/pages/table_cursos.dart';

class ScreenCursos extends StatefulWidget {
  const ScreenCursos({super.key});

  @override
  State<ScreenCursos> createState() => _ScreenCursosState();
}

class _ScreenCursosState extends State<ScreenCursos> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Courses(),
        ),
        Expanded( child: TableCursos()),
      ],
    );
  }
}
