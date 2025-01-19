import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/detailCourses/assign_course_dialog.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';

Future<void> addDetailCourse(
    BuildContext context,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerCourse,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
    try {

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
                await MethodsDetailCourses().addDetailCourse(detailCourseInfoMap, id);
                clearControllers();
                refreshData();
            }, messageSuccess: 'Curso Asignado Correctamente',);
    });
    } catch (e) {
        showCustomSnackBar(context, 'Error: $e', Colors.red);
    }
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
    } catch (e) {
        showCustomSnackBar(context, 'Error: $e', Colors.red);
    }
}