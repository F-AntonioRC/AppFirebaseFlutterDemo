import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/employee/cursosPendientesDropdown.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/employeeService/database_methods_employee.dart';
import 'package:testwithfirebase/userNormal/serviceuser/firebase_service.dart';

/// Un `StatefulWidget` que muestra un cuadro de diálogo (`AlertDialog`) para cargar la 
/// constancia de un curso pendiente de un empleado previamente seleccionado.
///
/// Este componente está diseñado para integrarse con Firebase y permite al usuario seleccionar 
/// un curso pendiente para un empleado específico.
///
/// Parámetros:
/// - [dataChange]: Una cadena (`String`) que representa el nombre del empleado seleccionado.
/// - [idChange]: Una cadena (`String`) que representa el ID único del empleado.
///
/// Funcionalidades principales:
/// - Muestra el nombre del empleado en un campo de texto de solo lectura.
/// - Obtiene el CUPO del empleado desde Firestore usando el ID del empleado.
/// - A partir del CUPO, busca el `uid` del usuario asociado.
/// - Con el `uid` y el CUPO, consulta los cursos pendientes usando el servicio de Firebase.
/// - Muestra un `DropdownButtonFormField` para seleccionar el curso pendiente.
/// - Ofrece botones de acción (Cancelar y Actualizar) para manejar la confirmación o la cancelación.
///

class Uploaddocument extends StatefulWidget {
  // El statefulWidget Uploaddocument se engarga de cargar un documento ya existente a Storage
  // sin necesidad de que un usuario lo haga en su interfaz.
  final String
      dataChange; //Un `String` que representa el nombre del empleado seleccionado.
  final String idChange; //Un `String` que representa el Id único del empleado.

  const Uploaddocument(
      {super.key, required this.dataChange, required this.idChange});

  @override
  State<Uploaddocument> createState() => _UploaddocumentState();
}

class _UploaddocumentState extends State<Uploaddocument> {
  // Controladores para los campos del diálogo
  late TextEditingController _textController;
  late TextEditingController _idController;

 // Lista de cursos pendientes (aunque no se usa directamente aquí).
  List<Map<String, dynamic>> cursosPendientes = [];
    // Curso seleccionado en el dropdown.
  String? cursoSeleccionado;

   // Variables para CUPO y UID del usuar
  String? _cupo;
  String? _userId;

  /// Inicialización de los controladores para los campos de texto
  /// Los valores iniciales de los controladores se asignan desde las propiedades
  /// `dataChange` y `idChange`.
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.dataChange);
    _idController = TextEditingController(text: widget.idChange);

    // Llamada a la consulta
    consultarUserPorEmpleado();
  }

  /// Limpieza de recursos: Libera los controladores para evitar fugas de memoria.
  @override
  void dispose() {
    _textController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> consultarUserPorEmpleado() async {
    final idEmpleado = widget.idChange;
    final cupo =
        await DatabaseMethodsEmployee().obtenerCupoEmpleado(idEmpleado);
    if (cupo != null) {
      final userId = await DatabaseMethodsEmployee().obtenerUserIdPorCupo(cupo);
      if (userId != null) {
        debugPrint("UserId encontrado: $userId");
        setState(() {
          _cupo = cupo;
          _userId = userId;
        });
      } else {
        if (context.mounted) {
          showCustomSnackBar(context,
              "No se encontró el usuario asociado al CUPO.", Colors.red);
        }
      }
    } else {
      if(context.mounted) {
        showCustomSnackBar(context, "No se encontró el CUPO del empleado.", Colors.red);
      }
    }
  }

    /// Consulta los cursos pendientes del usuario utilizando FirebaseService.
  Future<List<Map<String, dynamic>>> fetchCursos() {
    if (_userId == null || _cupo == null) {
      return Future.value([]);
    }
    return FirebaseService().obtenerCursosPendientes(_userId!, _cupo!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text(
        'Subir contancia del empleado',
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Nombre del empleado",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            TextField(
                readOnly: true,
                controller: _textController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
                )),
            const SizedBox(height: 10.0),
            const Text('Seleccione el Curso',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            (_userId != null && _cupo != null)
                ? CursosPendientesDropdown(
                    cursosFuture: fetchCursos(),
                    onChanged: (value) {
                      debugPrint('Curso seleccionado: $value');
                      cursoSeleccionado = value;
                    },
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
      actions: [
        ActionsFormCheck(
          isEditing: true,
          onCancel: () => Navigator.pop(context),
          onUpdate: () async {
            if (cursoSeleccionado == null) {
              showCustomSnackBar(
                  context, "Por favor seleccione un curso.", Colors.red);
              return;
            }

            if (context.mounted) {
              showCustomSnackBar(
                  context,
                  "Curso seleccionado en onUpdate: $cursoSeleccionado usuario: $_userId",
                  greenColorLight);
            }
          },
        )
      ],
    );
  }
}
