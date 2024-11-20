import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/my_button.dart';

class CustomDialog extends StatelessWidget {
  final String employeeId;
  const CustomDialog({super.key, required this.employeeId});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Asignación de empleados"),
      content: Column(
        children: [
          Text("Id del empleado: $employeeId"),
          const SizedBox(height: 10.0),

        ],
      ),
      actions: [
        MyButton(text: "Cancelar", icon: const Icon(Icons.cancel_outlined), onPressed: () { Navigator.of(context).pop(); }, buttonColor: Colors.red,)
      ],
    );
  }
}
