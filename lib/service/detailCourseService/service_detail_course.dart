import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../components/custom_dialog.dart';
import 'database_detail_courses.dart';

class DialogHelper {
  static Future<void> showAddDialog({
    required BuildContext context,
    required Map<String, dynamic> selectedData,
    required VoidCallback onClearControllers,
  }) async {
    final MethodsDetailCourses databaseDetailCourses = MethodsDetailCourses();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          dataOne: selectedData['NameCourse'],
          dataTwo: selectedData['NombreArea'] ?? selectedData['sare'],
          accept: () async {
            final String id = randomAlphaNumeric(3);
            final detailCourseMap = {
              "IdDetailCourse": id,
              "IdCourse": selectedData['IdCourse'],
              "IdArea": selectedData['IdArea'],
              "IdSare": selectedData['IdSare'],
              "Estado": "Activo",
            };
            await databaseDetailCourses.addDetailCourse(detailCourseMap, id);
            onClearControllers();
          },
          messageSuccess: 'Curso asignado correctamente',
        );
      },
    );
  }

  static Future<void> showUpdateDialog({
    required BuildContext context,
    required Map<String, dynamic> initialData,
    required Map<String, dynamic> selectedData,
    required VoidCallback onClearControllers,
    required VoidCallback onClearProviderData,
  }) async {
    final MethodsDetailCourses databaseDetailCourses = MethodsDetailCourses();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          dataOne: selectedData['NameCourse'] ?? initialData['NameCourse'],
          dataTwo: selectedData['NombreArea'] ?? initialData['NombreArea'],
          accept: () async {
            final String documentId = initialData['IdDetailCourse'];
            final updateData = {
              "IdDetailCourse": documentId,
              "IdCourse": selectedData['IdCourse'] ?? initialData['IdCourse'],
              "IdArea": selectedData['IdArea'] ?? initialData['IdArea'],
              "IdSare": selectedData['IdSare'] ?? initialData['IdSare'],
            };
            await databaseDetailCourses.updateDetalleCursos(documentId, updateData);
            onClearControllers();
            onClearProviderData();
          },
          messageSuccess: 'Asignación editada correctamente',
        );
      },
    );
  }
}