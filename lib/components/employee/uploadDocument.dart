import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final String dataChange;
  final String idChange;

  const Uploaddocument({
    super.key,
    required this.dataChange,
    required this.idChange,
  });

  @override
  State<Uploaddocument> createState() => _UploaddocumentState();
}

class _UploaddocumentState extends State<Uploaddocument> {
  late TextEditingController _textController;
  late TextEditingController _idController;

  Map<String, dynamic>? cursoSeleccionado;

  String? _cupo;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.dataChange);
    _idController = TextEditingController(text: widget.idChange);
    consultarUserPorEmpleado();
  }

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
        setState(() {
          _cupo = cupo;
          _userId = userId;
        });
      } else {
        if (context.mounted) {
          showCustomSnackBar(
              context, "No se encontró el usuario asociado al CUPO.", wineLight);
        }
      }
    } else {
      if (context.mounted) {
        showCustomSnackBar(context, "No se encontró el CUPO del empleado.", wineLight);
      }
    }
  }

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
        'Subir constancia del empleado',
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text('Seleccione el Curso',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            (_userId != null && _cupo != null)
                ? CursosPendientesDropdown(
                    cursosFuture: fetchCursos(),
                    onChanged: (value) {
                      debugPrint('Curso seleccionado: ${value?['NombreCurso']}');
                      setState(() {
                        cursoSeleccionado = value;
                      });
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
                  context, "Por favor seleccione un curso.", wineLight);
              return;
            }

            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
              withData: true,
            );

            if (result == null) {
              if(context.mounted) {
                showCustomSnackBar(
                  context, "No se seleccionó ningún archivo.", Colors.red);
              }
              return;
            }

            final pickedFile = result.files.single;
            final fileName = pickedFile.name;
            final fileBytes = pickedFile.bytes;

            if (fileBytes == null) {
              if(context.mounted) {
              showCustomSnackBar(context, "No se pudo leer el archivo.", wineLight);
              }
              return;
            }

            final now = DateTime.now();
            final year = DateFormat('yyyy').format(now);

            final nombreCurso = cursoSeleccionado!['NombreCurso'];
            final trimestre = cursoSeleccionado!['Trimestre'];
            final dependencia = cursoSeleccionado!['Dependencia'];
            final idCurso = cursoSeleccionado!['IdCurso'];

            final storagePath = '$year/$trimestre/$dependencia/$nombreCurso/$fileName';
            final storageRef = FirebaseStorage.instance.ref().child(storagePath);

            try {
              final uploadTask = storageRef.putData(
                fileBytes,
                SettableMetadata(contentType: 'application/pdf'),
              );

              final snapshot = await uploadTask.whenComplete(() => null);
              final downloadUrl = await snapshot.ref.getDownloadURL();

              final firestore = FirebaseFirestore.instance;
              final userDocRef =
                  firestore.collection('CursosCompletados').doc(_userId);

              await userDocRef.set({
                'uid': _userId,
                'IdCursosCompletados': FieldValue.arrayUnion([idCurso]),
                'FechaCursoCompletado': FieldValue.arrayUnion([Timestamp.now()]),
                'Evidencias': FieldValue.arrayUnion([downloadUrl]),
                'completado': true,
              }, SetOptions(merge: true));

              if (context.mounted) {
                showCustomSnackBar(
                    context, "Evidencia subida correctamente", greenColorLight);
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                showCustomSnackBar(context, "Error al subir: $e", wineLight);
              }
            }
          },
        )
      ],
    );
  }
}
