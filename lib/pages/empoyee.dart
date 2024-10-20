import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/dropdown_list.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final List<String> dropdownsex = [
    'M',
    'F'
  ]; // VALORES DEL DROPDOWN
  String? sexdropdownValue;

  final List<String> dropdownState = ["Activo", "Inactivo"];
  String? stateDropdownValue;

  final List<String> dropdownArea = [
    "Jefatura",
    "Analista",
    "Enlace",
    "Auxiliar"
  ];
  String? areaDropdownValue;

  final List<String> dropdownSare = [
    "Archivo",
    "Juridico",
    "Administrativo",
    "Ciudadania"
  ];
  String? sareDropdownValue;

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController rfcController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        color: ligth,
        child: Padding(padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Añadir Curso", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              Row(
                children: [
                  Expanded(child: Column(children: [
                    const Text(
                      'Nombre del empleado',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    MyTextfileld(
                        hindText: "Campo Obligatorio*",
                        icon: const Icon(Icons.person),
                        controller: namecontroller,
                        obsecureText: false,
                        keyboardType: TextInputType.text),
                  ],)),
                  const SizedBox(width: 20.0),
                  Expanded(child: Column(children: [
                    const Text(
                      'Sexo',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    DropdownList(items: dropdownsex,
                      icon: const Icon(Icons.arrow_downward_rounded),
                      onChanged: (value) {
                        sexdropdownValue = value;
                      },),
                  ],)),
                ],
              ),
            const SizedBox(height: 15.0),
            Row(children: [
              Expanded(child: Column(
              children: [
                const Text(
                  'RFC del empleado',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                MyTextfileld(
                    hindText: "Campo Obligatorio*",
                    icon: const Icon(Icons.person),
                    controller: rfcController,
                    obsecureText: false,
                    keyboardType: TextInputType.text),
              ]
            )),
              const SizedBox(width: 20.0),
              Expanded(child: Column(
                children: [
                const Text(
                  'Estado',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownList(
                  items: dropdownState, icon: const Icon(Icons.arrow_downward_rounded), onChanged: (value) {
                  stateDropdownValue = value;
                },),
              ],)),
            ],),
            const SizedBox(height: 15.0),
            Row(children: [
              Expanded(child: Column(children: [
                const Text(
                  'Area',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20.0),
                DropdownList(
                  items: dropdownArea, icon: const Icon(Icons.arrow_downward_rounded), onChanged: (value) {
                  areaDropdownValue = value;
                },),
              ],)),
              const SizedBox(width: 20.0),
              Expanded(child: Column(children: [
                const Text(
                  'Sare',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20.0),
                DropdownList(
                  items: dropdownSare, icon: const Icon(Icons.arrow_downward_rounded), onChanged: (value) {
                  sareDropdownValue = value;
                },),
              ],))
            ],),
            const SizedBox(height: 20.0),
            Center(
                child: MyButton(
                  text: 'Añadir',
                  icon: const Icon(Icons.person_add_alt_rounded),
                  onPressed: () async {
                    try {
                      String id = randomAlphaNumeric(5);
                      Map<String, dynamic> employeeInfoMap = {
                        "Id": id,
                        "Nombre": namecontroller.text,
                        "Sexo": sexdropdownValue,
                        "RFC": rfcController.text,
                        "Estado": stateDropdownValue,
                        "Area": areaDropdownValue,
                        "Sare": sareDropdownValue
                      };
                      await DatabaseMethods().addEmployeeDetails(
                          employeeInfoMap, id);
                      showCustomSnackBar(
                          context, "Empleado agregado correctamente :D");
                    } catch (e) {
                      showCustomSnackBar(context, "Error: $e");
                    }
                  },
                )
            ),
          ],
        ),
      ),
    )
    )
    );
  }
}