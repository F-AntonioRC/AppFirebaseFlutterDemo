import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/cursos/card_table.dart';
import 'package:testwithfirebase/pages/courses/courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

  /// Pantalla principal para la sección de cursos.
  ///
  /// Este widget es un [StatefulWidget] que organiza la interfaz de la sección de cursos,
  /// mostrando el formulario de cursos y una PaginatedTable con los registros de la colección.
  /// Utiliza un [Provider] para acceder a un [EditProvider] que contiene los registros que se deben
  /// editar o visualizar.

class ScreenCursos extends StatefulWidget {
  const ScreenCursos({super.key});

  @override
  State<ScreenCursos> createState() => _ScreenCursosState();
}

class _ScreenCursosState extends State<ScreenCursos> {
  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para acceder a la información de edición de cursos.
    final coursesProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        // Área donde se muestra el formulario de los cursos.
        Expanded(
          child: Courses(
            initialData: coursesProvider.data,  // Se pasa la información inicial del provider si existe.
          ),
        ),
        // Área que muestra una PaginatedTable con la información de cursos
        const Expanded(child: CardTableCourses()),
      ],
    );
  }
}
