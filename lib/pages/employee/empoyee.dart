import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/dropdown_list.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/database.dart';
import 'package:testwithfirebase/util/responsive.dart';

class Employee extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const Employee({super.key, this.initialData});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  void _clearControllers() {
    namecontroller.clear();
    sexdropdownValue = null;
    _controllerArea.clearSelection();
    _controllerSare.clearSelection();
  }

  final List<String> dropdownsex = ["M", "F"]; // VALORES DEL DROPDOWN
  String? sexdropdownValue;

  final FirebaseDropdownController _controllerArea =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerSare =
      FirebaseDropdownController();

  TextEditingController namecontroller = TextEditingController();

  late final Map<String, dynamic>? initialData;

  void _initializeControllers(EditProvider provider) {
    if (provider.data != null) {
      namecontroller.text = provider.data?['Nombre'] ?? '';
      sexdropdownValue = provider.data?['Sexo'];
      if (provider.data?['Area'] != null) {
        _controllerArea.setDocument({'NombreArea': provider.data?['Area']});
      }

      if (provider.data?['Sare'] != null) {
        _controllerSare.setDocument({'sare': provider.data?['Sare']});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<EditProvider>(context, listen: false);
    _initializeControllers(provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _initializeControllers(provider);

    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.initialData != null
                      ? "Editar Empleado"
                      : "Añadir Empleado",
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
                          value: sexdropdownValue,
                          onChanged: (value) {
                            setState(
                              () {
                                sexdropdownValue = value;
                              },
                            );
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
                        FirebaseDropdown(
                            controller: _controllerArea,
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
                        const SizedBox(width: 20.0),
                        FirebaseDropdown(
                            controller: _controllerSare,
                            collection: 'Sare',
                            data: 'sare',
                            textHint: 'Seleccione una SARE')
                      ],
                    ))
                  ],
                ),
                const SizedBox(height: 20.0),
                Center(
                  widthFactor: 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.initialData == null)
                        MyButton(
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
                                "Area": _controllerArea
                                    .selectedDocument?['NombreArea'],
                                "IdArea":
                                    _controllerArea.selectedDocument?['IdArea'],
                                "IdSare": _controllerSare
                                    .selectedDocument?['IdSare '],
                                "Sare":
                                    _controllerSare.selectedDocument?['sare']
                              };
                              await DatabaseMethods()
                                  .addEmployeeDetails(employeeInfoMap, id);
                              if (context.mounted) {
                                showCustomSnackBar(
                                    context,
                                    "Empleado agregado correctamente :D",
                                    greenColor);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showCustomSnackBar(
                                    context, "Error: $e", Colors.red);
                              }
                            }
                            //Limpiar las entradas
                            _clearControllers();
                          },
                          buttonColor: greenColor,
                        ),
                      if (widget.initialData != null) ...[
                        MyButton(
                          text: 'Aceptar',
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () async {
                            try {
                              final String documentId =
                                  widget.initialData?['IdEmployee'];

                              Map<String, dynamic> updateData = {
                                "IdEmployee": documentId,
                                "Nombre": namecontroller.text,
                                "Sexo": sexdropdownValue,
                                "Estado": "Activo",
                                "Area": _controllerArea
                                    .selectedDocument?['NombreArea'],
                                "IdArea":
                                    _controllerArea.selectedDocument?['IdArea'],
                                "IdSare": _controllerSare
                                    .selectedDocument?['IdSare '],
                                "Sare":
                                    _controllerSare.selectedDocument?['sare']
                              };
                              await DatabaseMethods().updateEmployeeDetail(
                                  widget.initialData?['IdEmployee'],
                                  updateData);
                              if (context.mounted) {
                                showCustomSnackBar(
                                    context,
                                    "Empleado Actualizado correctamente :D",
                                    greenColor);
                                //Limpiar las entradas
                                _clearControllers();
                                //Limpiar los datos del provider
                                final provider = Provider.of<EditProvider>(
                                    context,
                                    listen: false);
                                provider.clearData();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showCustomSnackBar(
                                    context, "Error: $e", Colors.red);
                              }
                            }
                          },
                          buttonColor: greenColor,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        MyButton(
                          text: "Cancelar",
                          icon: const Icon(Icons.cancel_outlined),
                          buttonColor: Colors.red,
                          onPressed: () {
                            //Limpiar los datos del provider
                            final provider = Provider.of<EditProvider>(context,
                                listen: false);
                            provider.clearData();

                            //Limpiar las entradas
                            _clearControllers();
                          },
                        )
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        )));
  }
}