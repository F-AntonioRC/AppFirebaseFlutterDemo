import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/detailCourses/assign_course_dialog.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../handle_error_sentry.dart';

Future<void> addDetailCourse(
    BuildContext context,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerCourse,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {

    if(controllerCourse.selectedDocument == null) {
        showCustomSnackBar(context, 'Por favor seleccione un Curso para asignar', Colors.red);
        return;
    }

    if(controllerSare.selectedDocument == null && controllerOre.selectedDocument == null) {
        showCustomSnackBar(context, "Por favor, seleccione un ORE o Sare", Colors.red);
        return;
    }

    // Datos seleccionados
    String? selectedCourse = controllerCourse.selectedDocument?['NombreCurso'];
    String? selectedArea = controllerOre.selectedDocument?['Ore'];
    String? selectedSare = controllerSare.selectedDocument?['sare'];
    String? idCourse = controllerCourse.selectedDocument?['IdCurso'];
    String? idOre = controllerOre.selectedDocument?['IdOre'];
    String? idSare = controllerSare.selectedDocument?['IdSare'];

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