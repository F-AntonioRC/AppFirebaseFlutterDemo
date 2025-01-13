import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/MyPaginatedTable.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

class TableViewCourses extends StatelessWidget {
  final bool viewInactivos;
  final List<Map<String, dynamic>> filteredData;
  final MethodsCourses methodsCourses;
  final bool isActive;
  final Function() refreshTable;

  const TableViewCourses({
    super.key,
    required this.viewInactivos,
    required this.filteredData,
    required this.methodsCourses,
    required this.isActive,
    required this.refreshTable,
  });

  @override
  Widget build(BuildContext context) {
    const String idKey = "IdCourse";

    return Consumer<EditProvider>(builder: (context, editProvider, child) {
      return FutureBuilder(
        future: viewInactivos
            ? methodsCourses.getAllCoursesInac()
            : methodsCourses.getAllCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron cursos.'));
          } else {
            final data = filteredData.isEmpty ? snapshot.data! : filteredData;
            return MyPaginatedTable(
              headers: const [
                "Nombre",
                "Dependencia",
                "Trimestre",
                "Inicio curso",
                "Registro",
                "Envio Constancia"
              ],
              data: data,
              fieldKeys: const [
                "NameCourse",
                "Dependencia",
                "Trimestre",
                "FechaInicioCurso",
                "Fecharegistro",
                "FechaenvioConstancia"
              ],
              onEdit: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id);

                Provider.of<EditProvider>(context, listen: false).setData(selectedRow);
              },
              onDelete: (String id) async {
                try {
                  await methodsCourses.deleteCoursesDetail(id);
                  refreshTable();
                  if(context.mounted) {
                    showCustomSnackBar(context, "Curso eliminado correctamente", greenColor);
                  }
                } catch (e) {
                  if(context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              },
              idKey: idKey,
              onActive: isActive,
              activateFunction: (String id) async {
                try {
                  await methodsCourses.activateCoursesDetail(id);
                  refreshTable();
                  if(context.mounted) {
                    showCustomSnackBar(context, "Curso restaurado correctamente", greenColor);
                  }
                } catch (e) {
                  if(context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              },
            );
          }
        },
      );
    });
  }
}