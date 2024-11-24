import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/dropdown_list.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';
import 'package:testwithfirebase/util/responsive.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final List<String> dropdownsex = ['M', 'F']; // VALORES DEL DROPDOWN
  String? sexdropdownValue;

  final FirebaseDropdownController _controllerArea = FirebaseDropdownController();

  final FirebaseDropdownController _controllerSare = FirebaseDropdownController();

  TextEditingController namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Añadir Empleado",
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
                                controller: namecontroller,
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
                              items: dropdownsex,
                              icon: const Icon(Icons.arrow_downward_rounded),
                              onChanged: (value) {
                                sexdropdownValue = value;
                              },
                            ),
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
                              'Area',
                              style: TextStyle(
                                  fontSize: responsiveFontSize(context, 20),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 20.0),
                            FirebaseDropdown(controller: _controllerArea,
                                collection: 'Area', data: 'Nombre', textHint: 'Seleccione un area')
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
                            const SizedBox(width: 20.0),
                            FirebaseDropdown(
                                controller: _controllerSare, collection: 'Sare',
                                data: 'sare', textHint: 'Seleccione una SARE')
                          ],
                        ))
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      widthFactor: 0.5,
                      child: MyButton(
                        text: 'Agregar',
                        icon: const Icon(Icons.person_add_alt_rounded),
                        onPressed: () async {
                          try {
                            String id = randomAlphaNumeric(3);
                            Map<String, dynamic> employeeInfoMap = {
                              "IdEmployee": id,
                              "Nombre": namecontroller.text,
                              "Sexo": sexdropdownValue,
                              "Estado": "Activo",
                              "Area": _controllerArea.selectedDocument?['Nombre'],
                              "Sare": _controllerSare.selectedDocument?['sare']
                            };
                            await DatabaseMethods()
                                .addEmployeeDetails(employeeInfoMap, id);
                            showCustomSnackBar(
                                context, "Empleado agregado correctamente :D", greenColor);
                          } catch (e) {
                            showCustomSnackBar(context, "Error: $e", Colors.red);
                          }
                          //Limpiar las entradas
                          setState(() {
                            namecontroller.clear();
                            sexdropdownValue = null;
                            _controllerArea.clearSelection();
                            _controllerSare.clearSelection();
                          });
                        },
                        buttonColor: greenColor,
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
