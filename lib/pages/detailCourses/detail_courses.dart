import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/pages/detailCourses/form_body_detail_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/detailCourseService/detailCourse_form_logic.dart';
import 'package:testwithfirebase/service/detailCourseService/service_detail_course.dart';

class DetailCourses extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const DetailCourses({super.key, this.initialData});

  @override
  State<DetailCourses> createState() => _DetailCoursesState();
}

class _DetailCoursesState extends State<DetailCourses> {
  final DetailCourseFormLogic _detailCourseFormLogic = DetailCourseFormLogic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      if (provider.data != null) {
        _detailCourseFormLogic.initializeControllers(context, provider);
      }
    });
  }

  String? selectedCourse;
  String? selectedArea;
  String? selectedSare;
  String? idCourse;
  String? idArea;
  String? idSare;

  void _updateData() {
    setState(() {
      // Actualizar las variables de instancia directamente
      selectedCourse =
      _detailCourseFormLogic.controllerCourses.selectedDocument?['NameCourse'];
      selectedArea =
      _detailCourseFormLogic.controllerArea.selectedDocument?['NombreArea'];
      selectedSare =
      _detailCourseFormLogic.controllerSare.selectedDocument?['sare'];
      idCourse =
      _detailCourseFormLogic.controllerCourses.selectedDocument?['IdCourse'];
      idArea =
      _detailCourseFormLogic.controllerArea.selectedDocument?['IdArea'];
      idSare =
      _detailCourseFormLogic.controllerSare.selectedDocument?['IdSare'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _detailCourseFormLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
          child: Column(children: [
            FormBodyDetailCourses(
                controllerCourse: _detailCourseFormLogic.controllerCourses,
                controllerSare: _detailCourseFormLogic.controllerSare,
                controllerArea: _detailCourseFormLogic.controllerArea,
                title: widget.initialData != null
                    ? "Editar Asignación de cursos"
                    : "Asignar Cursos"),
            const SizedBox(height: 20.0),
            ActionsFormCheck(
              isEditing: widget.initialData != null,
              onAdd: () async {
                await addDetailCourse(
                    context,
                    _detailCourseFormLogic.controllerSare,
                    _detailCourseFormLogic.controllerArea,
                    _detailCourseFormLogic.controllerCourses,
                    _detailCourseFormLogic.clearControllers,
                    () => _detailCourseFormLogic.refreshProviderData(context)
                );
              },
              onUpdate: () async {
                _updateData();
                final String documentId = widget.initialData?['IdDetailCourse'];
                updateDetailCourses(
                    context,
                    documentId,
                    selectedCourse,
                    selectedArea,
                    selectedSare,
                    idCourse,
                    idArea,
                    idSare,
                    widget.initialData,
                    () => _detailCourseFormLogic.clearProviderData(context),
                    () => _detailCourseFormLogic.refreshProviderData(context)
                );
                _detailCourseFormLogic.clearControllers();
              },
              onCancel: () {
                _detailCourseFormLogic.clearControllers();
                _detailCourseFormLogic.clearProviderData(context);
              },
            )
          ]),
        ));
  }
}
