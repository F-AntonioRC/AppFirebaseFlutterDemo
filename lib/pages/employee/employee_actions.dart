import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

import '../../components/my_button.dart';
import 'Employee_controller.dart';

class EmployeeActions extends StatelessWidget {
  const EmployeeActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EmployeeController>(context);
    final isEditing = controller.nameController.text.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyButton(
          text: isEditing ? "Actualizar" : "Agregar",
          icon: Icon(isEditing ? Icons.edit : Icons.add),
          buttonColor: greenColor,
          onPressed: () async {
            // Lógica de agregar/editar
          },
        ),
        if (isEditing) ...[
          const SizedBox(width: 10),
          MyButton(
            text: "Cancelar",
            icon: const Icon(Icons.cancel_outlined),
            buttonColor: Colors.red,
            onPressed: () => controller.resetForm(),
          ),
        ],
      ],
    );
  }
}
