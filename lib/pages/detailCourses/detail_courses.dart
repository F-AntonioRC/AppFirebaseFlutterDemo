import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/pages/detailCourses/form_body_detail_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/detailCourseService/detailCourse_form_logic.dart';
import 'package:testwithfirebase/service/detailCourseService/service_detail_course.dart';

  /// La clase `DetailCourses` es un Widget que representa la pantalla para asignar cursos,
  /// en la cual se muestra un formulario para añadir o editar cursos asignador, junto con las
  /// acciones correspondientes para guardar, actualizar o cancelar la operación.
  ///
  /// Si se proporciona información inicial a través de [initialData], el formulario
  /// se inicializa en modo edición; de lo contrario, se asume que se agregará un nuevo curso.

class DetailCourses extends StatefulWidget {
  /// Datos iniciales del curso asignado que se desean editar. Si es `null`, se mostrará el formulario
  /// en modo "Añadir Curso asignado".
  final Map<String, dynamic>? initialData;

  /// Constructor del widget.
  const DetailCourses({super.key, this.initialData});

  @override
  State<DetailCourses> createState() => _DetailCoursesState();
}

class _DetailCoursesState extends State<DetailCourses> {
  /// Instancia de la lógica de formulario para los cursos asignados que administra los controladores
  /// y las acciones específicas del formulario.
  final DetailCourseFormLogic _detailCourseFormLogic = DetailCourseFormLogic();

  @override
  void initState() {
    super.initState();
    // Se utiliza addPostFrameCallback para ejecutar la inicialización de los controladores
    // después de que se haya renderizado el primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      // Si existen datos en el provider, se inicializan los controladores con dichos datos.
      if (provider.data != null) {
        _detailCourseFormLogic.initializeControllers(context, provider);
      }
    });
  }
  // Variables para guardar los valores asignados de la colección correspondiente
  String? selectedCourse;
  String? selectedOre;
  String? selectedSare;
  String? idCourse;
  String? idOre;
  String? idSare;

  void _updateData() {
    setState(() {
      // Actualizar las variables de instancia directamente
      selectedCourse =
      _detailCourseFormLogic.controllerCourses.selectedDocument?['NombreCurso'];
      selectedOre =
      _detailCourseFormLogic.controllerOre.selectedDocument?['Ore'];
      selectedSare =
      _detailCourseFormLogic.controllerSare.selectedDocument?['sare'];
      idCourse =
      _detailCourseFormLogic.controllerCourses.selectedDocument?['IdCourse'];
      idOre =
      _detailCourseFormLogic.controllerOre.selectedDocument?['IdOre'];
      idSare =
      _detailCourseFormLogic.controllerSare.selectedDocument?['IdSare'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para que el widget escuche cambios en los datos.
    final provider = Provider.of<EditProvider>(context);
    // Se vuelve a inicializar los controladores para sincronizar los datos.
    _detailCourseFormLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
          child: Column(children: [
            // Se muestra el formulario con la información del curso asignado.
            // El título varía según se esté en modo edición o en modo agregar.
            // Tambien estan los controladores de los datos almacenados en el registro o para añadir.
            FormBodyDetailCourses(
                controllerCourse: _detailCourseFormLogic.controllerCourses,
                controllerSare: _detailCourseFormLogic.controllerSare,
                controllerOre: _detailCourseFormLogic.controllerOre,
                title: widget.initialData != null
                    ? "Editar Asignación de cursos"
                    : "Asignar Cursos"),
            const SizedBox(height: 20.0),
            // Se muestran las acciones del formulario, que varían según si se está
            // en modo edición o en modo agregar.
            ActionsFormCheck(
              isEditing: widget.initialData != null,
              onAdd: () async {
                // Llama a la función para asignar un nuevo curso.
                await addDetailCourse(
                    context,
                    _detailCourseFormLogic.controllerSare,
                    _detailCourseFormLogic.controllerOre,
                    _detailCourseFormLogic.controllerCourses,
                    _detailCourseFormLogic.clearControllers,
                    () => _detailCourseFormLogic.refreshProviderData(context)
                );
              },
              onUpdate: () async {
                // Se obtiene el identificador del curso asignado a editar.
                _updateData();
                final String documentId = widget.initialData?['IdDetalleCurso'];
                // Llama a la función para actualizar el curso asigmado con la información proporcionada.
                updateDetailCourses(
                    context,
                    documentId,
                    selectedCourse,
                    selectedOre,
                    selectedSare,
                    idCourse,
                    idOre,
                    idSare,
                    widget.initialData,
                    // Limpia los datos que vienen del provider.
                    () => _detailCourseFormLogic.clearProviderData(context),
                    // Actualiza la parte de la UI con los registros de los cursos.
                    () => _detailCourseFormLogic.refreshProviderData(context)
                );
                // Limpia los controladores después de la actualización.
                _detailCourseFormLogic.clearControllers();
              },
              onCancel: () {
                // Limpia los controladores y los datos del provider en caso de cancelación.
                _detailCourseFormLogic.clearControllers();
                _detailCourseFormLogic.clearProviderData(context);
              },
            )
          ]),
        ));
  }
}
