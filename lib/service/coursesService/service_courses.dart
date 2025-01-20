import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

import '../../components/formPatrts/custom_snackbar.dart';
import '../../dataConst/constand.dart';
import '../handle_error_sentry.dart';

Future<void> addCourse(
    BuildContext context,
    TextEditingController nameCourseController,
    TextEditingController nomenclaturaController,
    TextEditingController dateController,
    TextEditingController registroController,
    TextEditingController envioConstanciaController,
    FirebaseDropdownController controllerDependency,
    String? trimestreValue,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {

    if(nameCourseController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa un nombre de Curso", Colors.red);
      return;
    }

    if(controllerDependency.selectedDocument == null) {
      showCustomSnackBar(context, "Por favor, seleccione una dependencia", Colors.red);
      return;
    }

    if(trimestreValue == null) {
      showCustomSnackBar(context, "Por favor, selecciona un Trimestre", Colors.red);
      return;
    }

    if(controllerDependency.selectedDocument == null) {
      showCustomSnackBar(context, "Por favor, selecciona una Dependencia", Colors.red);
      return;
    }

    if(dateController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa una fecha de Inicio", Colors.red);
      return;
    }

    if(registroController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa una fecha de Registro", Colors.red);
      return;
    }

    if(envioConstanciaController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa una fecha para las Constancias", Colors.red);
      return;
    }

    String id = randomAlphaNumeric(3);
    Map<String, dynamic> courseInfoMap = {
      "IdCurso": id,
      "NombreCurso": nameCourseController.text.toUpperCase(),
      "NomenclaturaCurso": nomenclaturaController.text,
      "FechaInicioCurso": dateController.text,
      "FechaRegistro": registroController.text,
      "FechaEnvioConstancia": envioConstanciaController.text,
      "IdDependencia" : controllerDependency.selectedDocument?['IdDependencia'],
      "Dependencia" : controllerDependency.selectedDocument?['NombreDependencia'],
      "Trimestre": trimestreValue,
      "Estado": "Activo"
    };
    try {
    await MethodsCourses().addCourse(courseInfoMap, id);
    if (context.mounted) {
      showCustomSnackBar(
          context, "Curso añadido correctamente", greenColor);
    }
    clearControllers();
    refreshData();

  }  on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
      handleError(
          context: context,
          exception: e,
          stackTrace: stackTrace,
          operation: 'Agregar Curso',
          customMessage: 'Error de Firebase: ${e.message}',
          contextData: {
            'IdCurso': id,
            'Datos: ': courseInfoMap,
          });
    }
  } catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'addCourse');
      },
    );
  }
}

Future<void> updateCourse(
    BuildContext context,
    Map<String, dynamic>? initialData,
    String documentId,
    TextEditingController nameCourseController,
    TextEditingController nomenclaturaController,
    TextEditingController dateController,
    TextEditingController registroController,
    TextEditingController envioConstanciaController,
    FirebaseDropdownController controllerDependency,
    String? trimestreValue,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
    Map<String, dynamic> updateInfoMap = {
      "IdCurso": documentId,
      "NombreCurso": nameCourseController.text.toUpperCase(),
      "Trimestre": trimestreValue.toString(),
      "NomenclaturaCurso": nomenclaturaController.text,
      "FechaInicioCurso": dateController.text,
      "FechaRegistro": registroController.text,
      "FechaEnvioConstancia": envioConstanciaController.text,
      'Dependencia':
      controllerDependency.selectedDocument?['NombreDependencia'] ??
          initialData?['Dependencia'],
      'IdDependencia':
      controllerDependency.selectedDocument?['IdDependencia'] ??
          initialData?['IdDependencia'],
    };
    try{
    await MethodsCourses().updateCourse(documentId, updateInfoMap);
    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Curso actualizado correctamente",
        greenColor,
      );
    }
    // Limpiar los controladores
    clearControllers();
    refreshData();

  } on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
      handleError(
          context: context,
          exception: e,
          stackTrace: stackTrace,
          operation: 'Editar Curso',
          customMessage: 'Error de Firebase: ${e.message}',
          contextData: {
            'IdCurso': documentId,
            'Datos: ': updateInfoMap,
          });
    }
  } catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'updateCourse');
      },
    );
  }
}