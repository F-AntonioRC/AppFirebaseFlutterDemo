import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/pages/courses/form_body_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/coursesService/course_form_logic.dart';
import 'package:testwithfirebase/service/coursesService/service_courses.dart';

  /// La clase `Courses` es un Widget que representa la pantalla de cursos, en el cual se muestra
  /// un formulario para añadir o editar cursos, junto con las acciones correspondientes para
  /// guardar, actualizar o cancelar la operación.
  ///
  /// Si se proporciona información inicial a través de [initialData], el formulario
  /// se inicializa en modo edición; de lo contrario, se asume que se agregará un nuevo curso.

class Courses extends StatefulWidget {
  /// Datos iniciales del curso que se desean editar. Si es `null`, se mostrará el formulario
  /// en modo "Añadir Curso".
  final Map<String, dynamic>? initialData;

  /// Constructor del widget.
  const Courses({super.key, this.initialData});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  /// Instancia de la lógica de formulario para cursos que administra los controladores
  /// y las acciones específicas del formulario.
  final CourseFormLogic _courseLogic = CourseFormLogic();

  @override
  void initState() {
    super.initState();
    // Se utiliza addPostFrameCallback para ejecutar la inicialización de los controladores
    // después de que se haya renderizado el primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      // Si existen datos en el provider, se inicializan los controladores con dichos datos.
      if (provider.data != null) {
        _courseLogic.initializeControllers(context, provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para que el widget escuche cambios en los datos.
    final provider = Provider.of<EditProvider>(context);
    // Se vuelve a inicializar los controladores para sincronizar los datos.
    _courseLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(
        children: [
          // Se muestra el formulario con la información del curso.
          // El título varía según se esté en modo edición o en modo agregar.
          // Tambien estan los controladores de los datos almacenados en el registro o para añadir.
          FormBodyCourses(
            title: widget.initialData != null ? "Editar Curso" : "Añadir Curso",
            nameCourseController: _courseLogic.nameCourseController,
            dropdowntrimestre: _courseLogic.dropdowntrimestre,
            trimestreValue: _courseLogic.trimestreValue,
            dateController: _courseLogic.dateController,
            registroController: _courseLogic.registroController,
            envioConstanciaController: _courseLogic.envioConstanciaController,
            controllerDependency: _courseLogic.controllerDependency,
            onChangedDropdownList: (value) {
              // Actualiza el valor del trimestre al cambiar la opción del desplegable.
              _courseLogic.trimestreValue = value;
            },
          ),
          const SizedBox(height: 10.0),
          // Se muestran las acciones del formulario, que varían según si se está
          // en modo edición o en modo agregar.
          ActionsFormCheck(
            isEditing: widget.initialData != null,
            onAdd: () async {
              // Llama a la función para añadir un nuevo curso.
              await addCourse(
                  context,
                  _courseLogic.nameCourseController,
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
              // Se obtiene el identificador del curso a editar.
              final String documentId = widget.initialData?['IdCurso'];
              // Llama a la función para actualizar el curso con la información proporcionada.
              await updateCourse(
                  context,
                  widget.initialData,
                  documentId,
                  _courseLogic.nameCourseController,
                  _courseLogic.dateController,
                  _courseLogic.registroController,
                  _courseLogic.envioConstanciaController,
                  _courseLogic.controllerDependency,
                  _courseLogic.trimestreValue,
                  // Limpia los datos que vienen del provider.
                  () => _courseLogic.clearProviderData(context),
                  // Actualiza la parte de la UI con los registros de los cursos.
                  () => _courseLogic.refreshProviderData(context)
              );
              // Limpia los controladores después de la actualización.
              _courseLogic.clearControllers();
            },
            onCancel: () {
              // Limpia los controladores y los datos del provider en caso de cancelación.
              _courseLogic.clearControllers();
              _courseLogic.clearProviderData(context);
            },
          ),
        ],
      ),
    ));
  }
}