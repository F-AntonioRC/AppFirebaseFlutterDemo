import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/cursos/card_table.dart';
import 'package:testwithfirebase/pages/courses/courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

class ScreenCursos extends StatefulWidget {
  const ScreenCursos({super.key});

  @override
  State<ScreenCursos> createState() => _ScreenCursosState();
}

class _ScreenCursosState extends State<ScreenCursos> {
  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        Expanded(
          child: Courses(
            initialData: coursesProvider.data,
          ),
        ),
        const Expanded(child: CardTableCourses()),
      ],
    );
  }
}
