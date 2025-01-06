import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

import '../../components/custom_snackbar.dart';
import '../../dataConst/constand.dart';

Future<void> addCourse(
    BuildContext context,
    TextEditingController nameCourseController,
    TextEditingController nomenclaturaController,
    TextEditingController dateController,
    TextEditingController registroController,
    TextEditingController envioConstanciaController,
    String? trimestreValue,
    VoidCallback clearControllers
    ) async {

  try {

    if(nameCourseController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa un nombre", Colors.red);
      return;
    }

    if(trimestreValue == null) {
      showCustomSnackBar(context, "Por favor, selecciona un Trimestre", Colors.red);
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
      "IdCourse": id,
      "NameCourse": nameCourseController.text,
      "NomenclaturaCurso": nomenclaturaController.text,
      "FechaInicioCurso": dateController.text,
      "Fecharegistro": registroController.text,
      "FechaenvioConstancia": envioConstanciaController.text,
      "Trimestre": trimestreValue,
      "Estado": "Activo"
    };

    await MethodsCourses().addCourse(courseInfoMap, id);
    if (context.mounted) {
      showCustomSnackBar(
          context, "Curso añadido correctamente", greenColor);
    }
    clearControllers();

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
    String? trimestreValue,
    VoidCallback clearControllers
    ) async {
  try{
    Map<String, dynamic> updateInfoMap = {
      "IdCourse": documentId,
      "NameCourse": nameCourseController.text,
      "NomenclaturaCurso": nomenclaturaController.text,
      "FechaInicioCurso": dateController.text,
      "Fecharegistro": registroController.text,
      "FechaenvioConstancia": envioConstanciaController.text,
      "Trimestre": trimestreValue,
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

  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}