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
  final FirebaseDropdownController _controllerCupo =
      FirebaseDropdownController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Asignación de datos",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Seleccione CUPO",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10.0),
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
