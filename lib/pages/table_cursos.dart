import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/my_table.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database_courses.dart';

class TableCursos extends StatefulWidget {
  const TableCursos({super.key});

  @override
  State<TableCursos> createState() => _TableCursosState();
}

class _TableCursosState extends State<TableCursos> {
  final MethodsCourses methodsCourses = MethodsCourses();
  final List<String> headers = [
    "Nombre del Curso",
    "Fecha inicio curso",
    "Fecha de registro",
    "Fecha de envio de Constancia"
  ];
  final List<String> fieldKeys = [
    "NameCourse",
    "Fecharegistro",
    "FechaInicioCurso",
    "FechaenvioConstancia",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: FutureBuilder(
                    future: methodsCourses.getAllCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No courses found.'));
                      } else {
                        final data = snapshot.data!;
                        return MyTable(
                          headers: headers,
                          data: data,
                          fieldKeys: fieldKeys,
                          onEdit: (String id) {  },
                          onDelete: (String id) async {
                            try{
                              await methodsCourses.deleteCoursesDetail(id);
                              showCustomSnackBar(context, "Curso eliminado correctamente", greenColor);
                            } catch (e) {
                              showCustomSnackBar(context, "Error: $e", Colors.red);
                            }

                          },
                          idKey: 'Id',);
                      }
                    })
          ),
        ),
      ),
    );
  }
}
