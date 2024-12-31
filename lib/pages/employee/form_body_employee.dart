import 'package:flutter/material.dart';
import '../../components/dropdown_list.dart';
import '../../components/firebase_dropdown.dart';
import '../../components/my_textfileld.dart';
import '../../util/responsive.dart';

class FormBodyEmployee extends StatelessWidget {
  final TextEditingController nameController;
  final FirebaseDropdownController controllerDependency;
  final FirebaseDropdownController controllerArea;
  final FirebaseDropdownController controllerSare;
  final List<String> dropdownSex;
  final String? sexDropdownValue;
  final Function(String?)? onChangedDropdownList;
  final String title;

  const FormBodyEmployee(
      {super.key,
      required this.nameController,
      required this.controllerDependency,
      required this.controllerArea,
      required this.controllerSare,
      required this.dropdownSex,
      this.sexDropdownValue,
      required this.onChangedDropdownList,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: responsiveFontSize(context, 24),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  'Nombre del empleado',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                MyTextfileld(
                    hindText: "Campo Obligatorio*",
                    icon: const Icon(Icons.person),
                    controller: nameController,
                    keyboardType: TextInputType.text),
              ],
            )),
            const SizedBox(width: 20.0),
            Expanded(
                child: Column(
              children: [
                Text(
                  'Sexo',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownList(
                    items: dropdownSex,
                    icon: const Icon(Icons.arrow_downward_rounded),
                    value: sexDropdownValue,
                    onChanged: onChangedDropdownList),
              ],
            )),
          ],
        ),
        const SizedBox(height: 15.0),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  'Dependencia',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    controller: controllerDependency,
                    collection: 'Dependencia',
                    data: 'NombreDependencia',
                    textHint: 'Seleccione una opción')
              ],
            )),
            const SizedBox(width: 20.0),
            Expanded(
                child: Column(
              children: [
                Text(
                  'Area',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    controller: controllerArea,
                    collection: 'Area',
                    data: 'NombreArea',
                    textHint: 'Seleccione un area')
              ],
            )),
            const SizedBox(width: 20.0),
            Expanded(
                child: Column(
              children: [
                Text(
                  'Sare',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                    controller: controllerSare,
                    collection: 'Sare',
                    data: 'sare',
                    textHint: 'Seleccione SARE')
              ],
            )),
          ],
        ),
      ],
    );
  }
}
