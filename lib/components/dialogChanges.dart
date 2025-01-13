import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown.dart';
import 'package:testwithfirebase/service/employeeService/service_employee.dart';
import 'firebase_reusable/firebase_dropdown_controller.dart';

class DialogChanges extends StatefulWidget {
  final String dataChange;
  final String idChange;
  final Function() refreshTable;

  const DialogChanges(
      {super.key,
      required this.dataChange,
      required this.idChange,
      required this.refreshTable});

  @override
  State<DialogChanges> createState() => _DialogChangesState();
}

class _DialogChangesState extends State<DialogChanges> {
  late TextEditingController _textController;

  late TextEditingController _idController;

  final FirebaseDropdownController _controllerCupo =
      FirebaseDropdownController();

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el valor de dataChange
    _textController = TextEditingController(text: widget.dataChange);
    _idController = TextEditingController(text: widget.idChange);
  }

  @override
  void dispose() {
    // Libera el controlador para evitar fugas de memoria
    _textController.dispose();
    _idController.dispose();
    super.dispose();
  }

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
            const Text("Seleccione CUPO",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            FirebaseDropdown(
              enabled: true,
                controller: _controllerCupo,
                collection: 'User',
                data: 'CUPO',
                textHint: 'Seleccione CUPO del empleado'),
          ],
        ),
      ),
      actions: [
        Center(
          child: ActionsFormCheck(
            isEditing: true,
            onUpdate: () async {
              await assignCupo(context, _controllerCupo, widget.idChange,
                  widget.refreshTable);
            },
            onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
