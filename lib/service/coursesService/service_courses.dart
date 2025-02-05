import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';
import '../../components/formPatrts/custom_snackbar.dart';
import '../../dataConst/constand.dart';
import '../handle_error_sentry.dart';

/// Agrega un nuevo curso a la base de datos.
///
/// La función `addCourse` recopila la información ingresada por el usuario a través de varios
/// controladores de texto y un controlador para un desplegable (dependencia). Valida
/// que los campos requeridos no estén vacíos y, en caso contrario, muestra un mensaje de error.
/// Si la validación es exitosa, genera un identificador aleatorio para el curso, crea un mapa
/// con los datos del curso y llama a [MethodsCourses().addCourse] para agregar el curso en la base
/// de datos. Al finalizar, muestra un mensaje de éxito, limpia los controladores y refresca la UI.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [nameCourseController]: Controlador para el nombre del curso.
/// - [nomenclaturaController]: Controlador para la nomenclatura del curso.
/// - [dateController]: Controlador para la fecha de inicio del curso.
/// - [registroController]: Controlador para la fecha de registro del curso.
/// - [envioConstanciaController]: Controlador para la fecha de envío de constancia.
/// - [controllerDependency]: Controlador para el desplegable que selecciona la dependencia.
/// - [trimestreValue]: Valor seleccionado del trimestre.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
///
/// En caso de errores, se capturan y reportan a Sentry y se muestra un mensaje de error.
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
    // Validacion de los controladores
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
    // Generación de los Id's aleatorios
    String id = randomAlphaNumeric(3);
    // Crea el mapa con la información del curso.
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
    await MethodsCourses().addCourse(courseInfoMap, id); // Intenta agregar el curso a la base de datos.
    if (context.mounted) {
      showCustomSnackBar(
          context, "Curso añadido correctamente", greenColor);
    }
    clearControllers();
    refreshData();
      // Manejo de excepciones específicas de Firebase y reporte a Sentry.
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

/// Actualiza la información de un curso existente en la base de datos.
///
/// La función `updateCourse` toma la información actualizada del curso desde varios controladores de texto
/// y un controlador para un desplegable, construye un mapa con la información actualizada y
/// llama a [MethodsCourses] para actualizar el documento correspondiente en la base
/// de datos. Tras la actualización, se muestra un mensaje de éxito, se limpian los controladores y se
/// refrescan los datos.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [initialData]: Datos iniciales del curso que se están editando (opcional).
/// - [documentId]: Identificador del documento del curso a actualizar.
/// - [nameCourseController]: Controlador para el nombre del curso.
/// - [nomenclaturaController]: Controlador para la nomenclatura del curso.
/// - [dateController]: Controlador para la fecha de inicio del curso.
/// - [registroController]: Controlador para la fecha de registro del curso.
/// - [envioConstanciaController]: Controlador para la fecha de envío de constancia.
/// - [controllerDependency]: Controlador para el desplegable que selecciona la dependencia.
/// - [trimestreValue]: Valor seleccionado del trimestre.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
///
/// En caso de error, se captura y reporta la excepción a Sentry antes de relanzarla.
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