import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/pages/courses/form_body_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/coursesService/course_form_logic.dart';
import 'package:testwithfirebase/service/coursesService/service_courses.dart';

class Courses extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const Courses({super.key, this.initialData});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CourseFormLogic _courseLogic = CourseFormLogic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      if (provider.data != null) {
        _courseLogic.initializeControllers(context, provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _courseLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(
        children: [
          FormBodyCourses(
            title: widget.initialData != null ? "Editar Curso" : "Añadir Curso",
            nameCourseController: _courseLogic.nameCourseController,
            nomenclaturaController: _courseLogic.nomenclaturaController,
            dropdowntrimestre: _courseLogic.dropdowntrimestre,
            trimestreValue: _courseLogic.trimestreValue,
            dateController: _courseLogic.dateController,
            registroController: _courseLogic.registroController,
            envioConstanciaController: _courseLogic.envioConstanciaController,
            controllerDependency: _courseLogic.controllerDependency,
            onChangedDropdownList: (value) {
              _courseLogic.trimestreValue = value;
            },
          ),
          const SizedBox(height: 10.0),
          ActionsFormCheck(
            isEditing: widget.initialData != null,
            onAdd: () async {
              await addCourse(
                  context,
                  _courseLogic.nameCourseController,
                  _courseLogic.nomenclaturaController,
                  _courseLogic.dateController,
                  _courseLogic.registroController,
                  _courseLogic.envioConstanciaController,
                  _courseLogic.controllerDependency,
                  _courseLogic.trimestreValue,
                  _courseLogic.clearControllers,
                  () => _courseLogic.refreshProviderData(context)
              );
            },
            onUpdate: () async {
              final String documentId = widget.initialData?['IdCurso'];
              await updateCourse(
                  context,
                  widget.initialData,
                  documentId,
                  _courseLogic.nameCourseController,
                  _courseLogic.nomenclaturaController,
                  _courseLogic.dateController,
                  _courseLogic.registroController,
                  _courseLogic.envioConstanciaController,
                  _courseLogic.controllerDependency,
                  _courseLogic.trimestreValue,
                  () => _courseLogic.clearProviderData(context),
                  () => _courseLogic.refreshProviderData(context)
              );
              _courseLogic.clearControllers();
            },
            onCancel: () {
              _courseLogic.clearControllers();
              _courseLogic.clearProviderData(context);
            },
          ),
        ],
      ),
    ));
  }
}