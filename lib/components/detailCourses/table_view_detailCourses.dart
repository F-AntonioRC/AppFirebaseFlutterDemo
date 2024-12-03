import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/dialog_email.dart';
import 'package:testwithfirebase/service/database_detail_courses.dart';

import '../../dataConst/constand.dart';
import '../custom_snackbar.dart';
import '../my_table.dart';

class TableViewDetailCourses extends StatelessWidget {
  final bool viewInactivos;
  final List<Map<String, dynamic>> filteredData;
  final MethodsDetailCourses methodsDetailCourses;
  final bool isActive;
  final Function() refreshTable;

  const TableViewDetailCourses({super.key,
    required this.viewInactivos,
    required this.filteredData,
    required this.methodsDetailCourses,
    required this.isActive,
    required this.refreshTable});

  @override
  Widget build(BuildContext context) {
    const String idKey = "IdDetailCourse";

    return FutureBuilder(
      future: viewInactivos
          ? methodsDetailCourses.getDatosDetalleCursosInac()
          : methodsDetailCourses.getDatosDetalleCursosActivos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron cursos.'));
        } else {
          final data = filteredData.isEmpty ? snapshot.data! : filteredData;

          return MyTable(
            headers: const [
              "Nombre",
              "Area",
              "Sare",
              "Inicio curso",
              "Registro",
              "Envío de Constancia",
            ],
            data: data,
            fieldKeys: const [
              "NameCourse",
              "NombreArea",
              "sare",
              "FechaInicioCurso",
              "Fecharegistro",
              "FechaenvioConstancia",
            ],
            onEdit: (String id) {
              // Implementación futura
            },
            onDelete: (String id) async {
              try {
                await methodsDetailCourses.deleteDetalleCursos(id);
                refreshTable();
                if (context.mounted) {
                  showCustomSnackBar(
                      context, "Curso eliminado correctamente", Colors.green);
                }
              } catch (e) {
                if (context.mounted) {
                  showCustomSnackBar(context, "Error: $e", Colors.red);
                }
              }
            },
            onAssign: (String id) {
              showDialog(context: context,
                  builder: (BuildContext context) {
                return const DialogEmail(nameCourse: "Uso de Facebbok",
                  dateInit: "12/10/24", dateFinish: "24/10/14",
                  sendDocument: "30/10/24", nameArea: "Auxiliar", idArea: "1",);
                  });
            },
            iconAssign: const Icon(Icons.attach_email, color: Colors.blue,),
            idKey: idKey,
            onActive: isActive,
            activateFunction: (String id) async {
              try {
                await methodsDetailCourses.ActivarDetalleCurso(id);
                refreshTable();
                if (context.mounted) {
                  showCustomSnackBar(
                      context, "Curso restaurado correctamente", greenColor);
                }
              } catch (e) {
                if (context.mounted) {
                  showCustomSnackBar(context, "Error: $e", Colors.red);
                }
              }
            },
          );
        }
      },
    );
  }
}
