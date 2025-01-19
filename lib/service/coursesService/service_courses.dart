import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

import '../../components/formPatrts/custom_snackbar.dart';
import '../../dataConst/constand.dart';

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

  try {

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

    await MethodsCourses().addCourse(courseInfoMap, id);
    if (context.mounted) {
      showCustomSnackBar(
          context, "Curso añadido correctamente", greenColor);
    }
    clearControllers();
    refreshData();

  } catch(e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
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
  try{
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

  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}