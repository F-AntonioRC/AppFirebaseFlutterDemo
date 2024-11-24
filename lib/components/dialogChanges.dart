import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class Dialogchanges extends StatefulWidget {
  final String dataChange;

  const Dialogchanges({super.key, required this.dataChange});

  @override
  State<Dialogchanges> createState() => _DialogchangesState();
}

class _DialogchangesState extends State<Dialogchanges> {

  late TextEditingController _textController;

  final FirebaseDropdownController _controllerCupo =
      FirebaseDropdownController();

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el valor de dataChange
    _textController = TextEditingController(text: widget.dataChange);
  }

  @override
  void dispose() {
    // Libera el controlador para evitar fugas de memoria
    _textController.dispose();
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
            enabled: false,
            controller: _textController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0))
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
              onPressed: () => Navigator.pop(context),
              buttonColor: greenColor,
            ),
          ],
        )
      ],
    );
  }
}
