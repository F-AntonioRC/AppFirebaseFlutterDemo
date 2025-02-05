import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/detailCourses/assign_course_dialog.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../handle_error_sentry.dart';

/// Agrega un nuevo curso asignafo a la base de datos.
///
/// La función `addDetailCourse` recopila la información ingresada por el usuario a través de varios
/// controladores personalizados. Valida que los campos requeridos no estén vacíos y, en caso
/// contrario, muestra un mensaje de error.
/// Si la validación es exitosa, genera un identificador aleatorio para el curso asignado, crea un mapa
/// con los datos del curso asignado y llama a [MethodsDetailCourses] para agregar el curso en la base
/// de datos. Al finalizar, muestra un mensaje de éxito, limpia los controladores y refresca la UI.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [controllerSare]: Controlador para el Sare del curso Asignado.
/// - [controllerOre]: Controlador para el Ore del curso Asignado.
/// - [controllerCourse]: Controlador para seleccionar el valor del curso Asignado.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
///
/// En caso de errores, se capturan y reportan a Sentry y se muestra un mensaje de error.

Future<void> addDetailCourse(
    BuildContext context,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerCourse,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
    // Validación de los controladores.
    if(controllerCourse.selectedDocument == null) {
        showCustomSnackBar(context, 'Por favor seleccione un Curso para asignar', Colors.red);
        return;
    }

    if(controllerSare.selectedDocument == null && controllerOre.selectedDocument == null) {
        showCustomSnackBar(context, "Por favor, seleccione un ORE o Sare", Colors.red);
        return;
    }

    // Datos seleccionados para mostrar en el Widget personalizado `AssignCourseDialog`.
    String? selectedCourse = controllerCourse.selectedDocument?['NombreCurso'];
    String? selectedArea = controllerOre.selectedDocument?['Ore'];
    String? selectedSare = controllerSare.selectedDocument?['sare'];
    String? idCourse = controllerCourse.selectedDocument?['IdCurso'];
    String? idOre = controllerOre.selectedDocument?['IdOre'];
    String? idSare = controllerSare.selectedDocument?['IdSare'];

    // Mostrar el dialog con los parametros.
    showDialog(context: context, builder: (BuildContext context) {
        return AssignCourseDialog(
            dataOne: selectedCourse,
            dataTwo: selectedArea,
            dataThree: selectedSare,
            accept: () async {
                String id = randomAlphaNumeric(4);
                Map<String, dynamic> detailCourseInfoMap = {
                    'IdDetalleCurso' : id,
                    'IdOre' : idOre,
                    'IdCurso' : idCourse,
                    'IdSare' : idSare,
                    'Estado' : 'Activo'
                };
                try {
                    await MethodsDetailCourses().addDetailCourse(
                        detailCourseInfoMap, id);
                    clearControllers();
                    refreshData();
                } on FirebaseException catch (e, stackTrace) {
                    // Reporta el error a Sentry con contexto adicional
                    if (context.mounted) {
                        handleError(
                            context: context,
                            exception: e,
                            stackTrace: stackTrace,
                            operation: 'Asignar Cursos',
                            customMessage: 'Error de Firebase: ${e.message}',
                            contextData: {
                                'IdDetalleCurso': id,
                                'Datos: ': detailCourseInfoMap,
                            });
                    }
                } catch (e, stackTrace) {
                    // Reporta otros errores genéricos a Sentry
                    await Sentry.captureException(
                        e,
                        stackTrace: stackTrace,
                        withScope: (scope) {
                            scope.setTag('operation', 'Asignar Cursos');
                        },
                    );
                }
            }, messageSuccess: 'Curso Asignado Correctamente',);
    });
}

/// Actualiza la información de un curso asignado existente en la base de datos.
///
/// La función `updateDetailCourses` toma la información actualizada del curso asignado desde
/// varios controladores personalizados, construye un mapa con la información actualizada y
/// llama a [MethodsDetailCourses] para actualizar el documento correspondiente en la base
/// de datos. Tras la actualización, se muestra un mensaje de éxito, se limpian los controladores y se
/// refrescan los datos.
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [documentId]: Identificador del documento del curso asignado a actualizar.
/// - [idCourse]: Controlador opcional para el curso del curso Asignado.
/// - [idOre]: Controlador opcional para el Ore del curso Asignado.
/// - [idSare]: Controlador opcional para el Sare del curso Asignado.
/// - [selectedCourse]: Controlador opcional para el nombre del curso Asignado.
/// - [selectedOre]: Controlador opcional para el nombre del Ore Asignado.
/// - [selectedSare]: Controlador opcional para el nombre del Sare Asignado.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
Future<void> updateDetailCourses(
    BuildContext context,
    String documentId,
    String? selectedCourse,
    String? selectedOre,
    String? selectedSare,
    String? idCourse,
    String? idOre,
    String? idSare,
    Map<String, dynamic>? initialData,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
try{
    // Mostrar el dialog con los parametros.
    showDialog(context: context, builder: (BuildContext context) {
        return AssignCourseDialog(
            dataOne: selectedCourse,
            dataTwo: selectedOre,
            dataThree: selectedSare,
            accept: () async {
                Map<String, dynamic> updateData = {
                    'IdDetalleCurso' : documentId,
                    'IdOre': idOre ?? initialData?['IdOre'],
                    'IdSare': idSare ?? initialData?['IdSare'],
                    'IdCurso': idCourse ?? initialData?['IdCurso']
                };
                await MethodsDetailCourses().updateDetalleCursos(documentId, updateData);
            }, messageSuccess: 'Curso Editado Correctamente',);

    });
    clearControllers();
    refreshData();
    } on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
        handleError(
            context: context,
            exception: e,
            stackTrace: stackTrace,
            operation: 'Editar Asignar Cursos',
            customMessage: 'Error de Firebase: ${e.message}',
            contextData: {
                'IdEmpleado': documentId,
                'Datos: ': initialData,
            });
    }
} catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
            scope.setTag('operation', 'Editar Asignar Cursos');
        },
    );
}
}