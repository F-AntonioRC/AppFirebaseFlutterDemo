import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/detailCourses/card_detailCourse.dart';
import 'package:testwithfirebase/pages/detailCourses/detail_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

  /// Pantalla principal para la asignación de cursos.
  ///
  /// Este widget es un [StatefulWidget] que organiza la interfaz para la asignación de cursos,
  /// mostrando el formulario de este y una PaginatedTable con los registros de la colección.
  /// Utiliza un [Provider] para acceder a un [EditProvider] que contiene los registros que se deben
  /// editar o visualizar.

class PageDetailCourses extends StatefulWidget {
  const PageDetailCourses({super.key});

  @override
  State<PageDetailCourses> createState() => _PageDetailCoursesState();
}

class _PageDetailCoursesState extends State<PageDetailCourses> {
  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para acceder a la información de edición de cursos asinados.
    final detailCoursesProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        // Área donde se muestra el formulario para la asignación de cursos.
        Expanded(
            child: DetailCourses(
          initialData: detailCoursesProvider.data, // Se pasa la información inicial del provider si existe.
        )),
        // Área que muestra una PaginatedTable con la información de cursos asignados
        const Expanded(child: CardDetailCourse())
      ],
    );
  }
}
