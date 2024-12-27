import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/pages/employee/Employee_controller.dart';

class EmployeeHeader extends StatelessWidget {
  const EmployeeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EmployeeController>(context, listen: false);
    final isEditing = controller.nameController.text.isNotEmpty;

    return Text(
      isEditing ? "Editar Empleado" : "Añadir Empleado",
      style: Theme.of(context).textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }
}