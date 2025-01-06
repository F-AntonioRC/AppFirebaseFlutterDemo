import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/components/custom_dialog.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/pages/detailCourses/form_body_detail_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';

class DetailCourses extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const DetailCourses({super.key, this.initialData});

  @override
  State<DetailCourses> createState() => _DetailCoursesState();
}

class _DetailCoursesState extends State<DetailCourses> {
  final MethodsDetailCourses databaseDetailCourses = MethodsDetailCourses();

  final FirebaseDropdownController _controllerSare =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerArea =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerCourse =
      FirebaseDropdownController();

  bool isClearing = false;

  void _clearControllers() {
    _controllerSare.clearSelection();
    _controllerArea.clearSelection();
    _controllerCourse.clearSelection();
  }

  void _clearProviderData() {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  void _initializeControllers(EditProvider provider) {
    if (isClearing) return;

    final provider = Provider.of<EditProvider>(context, listen: false);
    final data = provider.data ?? widget.initialData;

    if (data != null) {
      _setControllerData(_controllerArea, 'IdArea', 'NombreArea', data);
      _setControllerData(_controllerCourse, 'IdCourse', 'NameCourse', data);
      _setControllerData(_controllerSare, 'IdSare', 'sare', data);
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

  void _stateInitial() {
    setState(() {
      // Obtener el curso y área seleccionados y actualizar el estado
      selectedCourse = _controllerCourse.selectedDocument?['NameCourse'];
      selectedArea = _controllerArea.selectedDocument?['NombreArea'];
      selectedSare = _controllerSare.selectedDocument?['sare'];
      idSare = _controllerSare.selectedDocument?['IdSare'];
      idCourse = _controllerCourse.selectedDocument?['IdCourse'];
      idArea = _controllerArea.selectedDocument?['IdArea'];
    });
  }

  void _setControllerData(FirebaseDropdownController controller, String idKey,
      String nameKey, Map<String, dynamic> data) {
    if (data[idKey] != null) {
      controller.setDocument({
        'Id': data[idKey],
        nameKey: data[nameKey],
      });
    }
  }

  String? selectedCourse;
  String? selectedArea;
  String? selectedSare;
  String? idCourse;
  String? idArea;
  String? idSare;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _initializeControllers(provider);

    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(children: [
        FormBodyDetailCourses(
            controllerCourse: _controllerCourse,
            controllerSare: _controllerSare,
            controllerArea: _controllerArea,
            title: widget.initialData != null
                ? "Editar Asignación de cursos"
                : "Asignar Cursos"),
        const SizedBox(height: 20.0),
        ActionsFormCheck(
          isEditing: widget.initialData != null,
          onAdd: () {
            _stateInitial();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    dataOne: selectedCourse,
                    dataTwo: selectedArea ?? selectedSare,
                    accept: () async {
                      String id = randomAlpha(4);
                      Map<String, dynamic> detailCourseMap = {
                        "IdDetailCourse": id,
                        "IdCourse": idCourse,
                        "IdArea": idArea,
                        "IdSare": idSare,
                        "Estado": "Activo"
                      };
                      await databaseDetailCourses.addDetailCourse(
                          detailCourseMap, id);
                      _clearControllers();
                    },
                    messageSuccess: 'Curso asignado correctamente',
                  );
                });
          },
          onUpdate: () {
            _stateInitial();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    dataOne: selectedCourse,
                    dataTwo: selectedArea ?? selectedSare,
                    accept: () async {
                      final String documentId =
                          widget.initialData?['IdDetailCourse'];
                      Map<String, dynamic> updateData = {
                        "IdDetailCourse": documentId,
                        "IdCourse":
                            _controllerCourse.selectedDocument?['IdCourse'] ??
                                widget.initialData?['IdCourse'],
                        "IdArea": _controllerArea.selectedDocument?['IdArea'] ??
                            widget.initialData?['IdArea'],
                        "IdSare": _controllerSare.selectedDocument?['IdSare'] ??
                            widget.initialData?['IdSare'],
                      };
                      await databaseDetailCourses.updateDetalleCursos(
                          documentId, updateData);
                      _clearControllers();
                      _clearProviderData();
                    },
                    messageSuccess: 'Asignación editada correctamente',
                  );
                });
          },
          onCancel: () {
            _clearControllers();
            _clearProviderData();
          },
        )
      ]),
    ));
  }
}
