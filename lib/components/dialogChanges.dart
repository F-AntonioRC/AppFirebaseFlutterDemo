import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';

class DialogChanges extends StatefulWidget {
  final String dataChange;
  final String idChange;

  const DialogChanges({super.key, required this.dataChange, required this.idChange});

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
      content: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
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
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              )
          ),
          const SizedBox(height: 10.0),
          const Text("Seleccione CUPO",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10.0),
          FirebaseDropdown(
              controller: _controllerCupo,
              collection: 'User',
              data: 'CUPO',
              textHint: 'Seleccione CUPO del empleado'),
        ],
      ),),
      actions: [
        Row(
          children: [
            MyButton(
              text: "Cancelar",
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => Navigator.pop(context),
              buttonColor: Colors.red,
            ),
            const SizedBox(width: 10.0),
            MyButton(
              text: "Aceptar",
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () async {
                final String cupoSeleccionado = _controllerCupo.selectedDocument?['CUPO'] ?? '';

                if(cupoSeleccionado.isNotEmpty) {
                  try {
                    await DatabaseMethods.addEmployeeCupo(widget.idChange, cupoSeleccionado);
                    Navigator.pop(context);
                    if(context.mounted) {
                      showCustomSnackBar(context, 'CUPO actualizado correctamente', greenColor);
                    }
                  } catch (e) {
                    if(context.mounted) {
                      showCustomSnackBar(context, "Error: $e", Colors.red);
                    }
                  }
                } else {
                  showCustomSnackBar(context, "Por favor selecciona una CUPO", greenColor);
                }
              },
              buttonColor: greenColor,
            ),
          ],
        )
      ],
    );
  }
}
