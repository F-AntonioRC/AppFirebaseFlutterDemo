import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/MyPaginatedTable.dart';
import 'package:testwithfirebase/components/sendEmail/dialog_email.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../../dataConst/constand.dart';
import '../../providers/edit_provider.dart';
import '../formPatrts/custom_snackbar.dart';

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
    const String idKey = "IdDetalleCurso";

    return Consumer<EditProvider>(builder:
    (context, editProvider, child) {
      return FutureBuilder(
        future: viewInactivos
            ? methodsDetailCourses.getDataDetailCourse(false)
            : methodsDetailCourses.getDataDetailCourse(true),
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
                "Ore",
                "Sare",
                "Estado",
                "Inicio curso",
                "Registro",
                "Envío Constancia",
              ],
              data: data,
              fieldKeys: const [
                "NombreCurso",
                "Ore",
                "sare",
                "Estado",
                "FechaInicioCurso",
                "FechaRegistro",
                "FechaEnvioConstancia",
              ],
              onEdit: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id);
                Provider.of<EditProvider>(context, listen: false)
                    .setData(selectedRow);
              },
              onDelete: (String id) async {
                try {
                  await methodsDetailCourses.deleteDetalleCursos(id);
                  refreshTable();
                  if (context.mounted) {
                    showCustomSnackBar(
                        context, "Curso eliminado correctamente", greenColor);
                  }
                } catch (e) {
                  if (context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              },
              onAssign: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id, orElse: () => {});
                if(selectedRow.isNotEmpty) {
                  final nameCourse = selectedRow['NombreCurso'] ?? '';
                  final dateInit = selectedRow['FechaInicioCurso'] ?? '';
                  final dateRegister = selectedRow['FechaRegistro'] ?? '';
                  final dateSendDocument = selectedRow['FechaEnvioConstancia'] ?? '';
                  final oreSelected = selectedRow['Ore'] ?? 'N/A';
                  final sareSelected = selectedRow['sare'] ?? 'N/A';
                  final idOreSelected = selectedRow['IdOre'] ?? 'N/A';
                  final idSareSelected = selectedRow['IdSare'] ?? 'N/A';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogEmail(
                        nameCourse: nameCourse,
                        dateInit: dateInit,
                        dateRegister: dateRegister,
                        sendDocument: dateSendDocument,
                        nameOre: oreSelected,
                        nameSare: sareSelected,
                        idOre: idOreSelected,
                        idSare: idSareSelected,
                      );
                    },
                  );
                } else {}

              },
              tooltipAssign: "Enviar correos",
              iconAssign: const Icon(Icons.outgoing_mail, color: Colors.blue,),
              idKey: idKey,
              onActive: isActive,
              activateFunction: (String id) async {
                try {
                  await methodsDetailCourses.activarDetalleCurso(id);
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
    });
  }
}
