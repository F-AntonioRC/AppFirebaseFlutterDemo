import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/my_button.dart';

class CustomDialog extends StatelessWidget {
  final String employeeId;
  const CustomDialog({super.key, required this.employeeId});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Asignación de empleados"),
      content: Text("Id del empleado: $employeeId"),
      actions: [
        MyButton(text: "Cancelar", icon: Icon(Icons.cancel_outlined), onPressed: () { Navigator.of(context).pop(); },)
      ],
    );
  }
}
