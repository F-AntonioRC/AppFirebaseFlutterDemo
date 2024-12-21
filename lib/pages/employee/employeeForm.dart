import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/dropdown_list.dart';
import '../../components/firebase_dropdown.dart';
import '../../components/my_textfileld.dart';
import 'Employee_controller.dart';

class EmployeeForm extends StatelessWidget {
  const EmployeeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EmployeeController>(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextfileld(
                hindText: "Campo Obligatorio*",
                icon: const Icon(Icons.person),
                controller: controller.nameController,
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownList(
                items: const ["M", "F"],
                icon: const Icon(Icons.arrow_downward_rounded),
                value: controller.sexDropdownValue,
                onChanged: (value) => controller.updateSex(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FirebaseDropdown(
                controller: controller.areaController,
                collection: 'Area',
                data: 'NombreArea',
                textHint: 'Seleccione un área',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FirebaseDropdown(
                controller: controller.sareController,
                collection: 'Sare',
                data: 'sare',
                textHint: 'Seleccione un SARE',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

