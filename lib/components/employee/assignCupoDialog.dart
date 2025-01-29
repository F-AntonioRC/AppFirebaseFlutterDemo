import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/my_textfileld.dart';
import 'package:testwithfirebase/service/employeeService/service_employee.dart';

/// Un widget que muestra un cuadro de diálogo para asignar un CUPO a un empleado.
/// Este cuadro de diálogo permite visualizar el nombre del empleado seleccionado, 
/// ingresar el CUPO asignado y ejecutar las acciones correspondientes (aceptar o cancelar).
class AssignCupoDialog extends StatefulWidget {
  final String dataChange; //Un `String` que representa el nombre del empleado seleccionado.
  final String idChange; //Un `String` que representa el Id único del empleado.
  final Function() refreshTable; //Una función (`Function()`) que se ejecuta para refrescar
  //la tabla de datos después de asignar el CUPO.

  const AssignCupoDialog(
      {super.key,
      required this.dataChange,
      required this.idChange,
      required this.refreshTable});

  @override
  State<AssignCupoDialog> createState() => _AssignCupoDialogState();
}

class _AssignCupoDialogState extends State<AssignCupoDialog> {
  // Controladores para los campos del diálogo
  late TextEditingController _textController;
  late TextEditingController _idController;
  final TextEditingController _controllerCupo = TextEditingController();

  /// Inicialización de los controladores para los campos de texto
  /// Los valores iniciales de los controladores se asignan desde las propiedades 
  /// `dataChange` y `idChange`.
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.dataChange);
    _idController = TextEditingController(text: widget.idChange);
  }

  /// Limpieza de recursos: Libera los controladores para evitar fugas de memoria.
  @override
  void dispose() {
    _textController.dispose();
    _idController.dispose();
    super.dispose();
  }

  /// Construcción del widget principal.
  /// Muestra un `AlertDialog` con los detalles del empleado y un campo para ingresar el CUPO.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text(
        "Asignación de datos",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text("Nombre del empleado",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            TextField(
                readOnly: true,
                controller: _textController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
            const SizedBox(height: 10.0),
            const Text("Asignar CUPO",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            MyTextfileld(
                hindText: 'Digite el CUPO',
                icon: const Icon( Icons.post_add),
                controller: _controllerCupo,
                keyboardType: TextInputType.number),
          ],
        ),
      ),
      actions: [
        Center(
          child: ActionsFormCheck(
            isEditing: true,
             // Acción al presionar "Aceptar", llama al método para asignar cupo con los valores
             // recibidos, manejando errores con Sentry para visualizar las excepciones.
            onUpdate: () async {
              try {
              await assignCupo(context, _controllerCupo, widget.idChange,
                  widget.refreshTable);
              } catch (e, stracktrace) {
                Sentry.captureException(
                  e,
                  stackTrace: stracktrace,
                  withScope: (scope) {
                    scope.setTag('Error_Widget_AssignCupoDialog', widget.idChange);
                  }
                );
              }
            },
            //Metodo para cerrar el dialog
            onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
