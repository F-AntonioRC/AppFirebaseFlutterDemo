import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/pages/courses/form_body_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/coursesService/service_courses.dart';

class Courses extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const Courses({super.key, this.initialData});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController nomenclaturaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController registroController = TextEditingController();
  TextEditingController envioConstanciaController = TextEditingController();
  final List<String> dropdowntrimestre = [
    "1",
    "2",
    "3",
    "4"
  ]; // VALORES DEL DROPDOWN
  String? trimestreValue;

  bool isClearing = false;

  void _clearControllers() {
    nameCourseController.clear();
    nomenclaturaController.clear();
    trimestreValue = null;
    dateController.clear();
    registroController.clear();
    envioConstanciaController.clear();
  }

  void _clearProvider() {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  void _initializeControllers(EditProvider provider) {
    //print(provider.data);
    if (isClearing) return;
    if (provider.data != null) {
      nameCourseController.text = provider.data?['NameCourse'];
      nomenclaturaController.text = provider.data?['NomenclaturaCurso'];
      trimestreValue = provider.data?['Trimestre'];
      dateController.text = provider.data?['FechaInicioCurso'];
      registroController.text = provider.data?['Fecharegistro'];
      envioConstanciaController.text = provider.data?['FechaenvioConstancia'];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      if (provider.data != null) {
        _initializeControllers(provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _initializeControllers(provider);

    return BodyWidgets(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FormBodyCourses(
                title: widget.initialData != null
                    ? "Editar Curso"
                    : "Añadir Curso",
                nameCourseController: nameCourseController,
                nomenclaturaController: nomenclaturaController,
                dropdowntrimestre: dropdowntrimestre,
                trimestreValue: trimestreValue,
                dateController: dateController,
                registroController: registroController,
                envioConstanciaController: envioConstanciaController,
                onChangedDropdownList: (value) {
                  setState(() {
                    trimestreValue = value;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              ActionsFormCheck(isEditing: widget.initialData != null,
                onAdd: () async {
                  await addCourse(
                      context,
                      nameCourseController,
                      nomenclaturaController,
                      dateController,
                      registroController,
                      envioConstanciaController,
                      trimestreValue,
                      _clearControllers);
                },
                onUpdate: () async {
                  final String documentId = widget.initialData?['IdCourse'];
                  await updateCourse(
                      context,
                      widget.initialData,
                      documentId,
                      nameCourseController,
                      nomenclaturaController,
                      dateController,
                      registroController,
                      envioConstanciaController,
                      trimestreValue,
                      _clearProvider);
                  _clearControllers();
                },
                onCancel: () {
                _clearControllers();
                _clearProvider();
                },
              ),
            ],
          ),
        ));
  }
}
