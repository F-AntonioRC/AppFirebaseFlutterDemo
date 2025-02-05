import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import '../../components/formPatrts/dropdown_list.dart';
import '../../components/firebase_reusable/firebase_dropdown.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../components/firebase_reusable/firebase_value_dropdown.dart';
import '../../components/formPatrts/my_textfileld.dart';
import '../../util/responsive.dart';

/// Estructura del formulario para añadir/editar empleados
///
/// Este widget muestra diversos campos de entrada y controladores como [FirebaseDropdownController],
/// [TextEditingController], [FirebaseValueDropdownController], listas de valores (List<String>),
/// entre otros para registrar la información de un empleado, como el nombre, email, puesto, area,
/// sección, sare, ore y sexo, almacenando los valores capturados para añadir o editar un empleado.

class FormBodyEmployee extends StatefulWidget {
  final TextEditingController nameController; // Controlador del nombre del empleado
  final TextEditingController emailController; // Controlador del email
  final FirebaseValueDropdownController controllerPuesto; // Controlador personalizado para seleccionar el puesto.
  final FirebaseValueDropdownController controllerArea; // Controlador personalizado para seleccionar el area.
  final FirebaseValueDropdownController controllerSection; // Controlador personalizado para seleccionar la sección.
  final FirebaseDropdownController controllerSare; // Controlador personalizado para seleccionar el Sare.
  final FirebaseDropdownController controllerOre; // Controlador personalizado para seleccionar el Ore.
  final List<String> dropdownSex; // Lista de valores para seleccionar el sexo del empleado.
  final String? sexDropdownValue; // Valor seleccionado para el sexo
  final Function(String?)? onChangedDropdownList; // Función que se ejecuta al cambiar la opción del sexo.
  final Function(String?)? onChangedFirebaseValue; // Función que se ejecuta al cambiar la opción del FirebaseValueDropdownController.
  final String title; // Titulo de la cabecera.

  const FormBodyEmployee(
      {super.key,
      required this.nameController,
      required this.controllerPuesto,
      required this.controllerArea,
      required this.controllerSare,
      required this.dropdownSex,
      this.sexDropdownValue,
      required this.onChangedDropdownList,
      required this.title,
      required this.controllerSection,
      required this.controllerOre,
      this.onChangedFirebaseValue,
      required this.emailController});

  @override
  State<FormBodyEmployee> createState() => _FormBodyEmployeeState();
}

class _FormBodyEmployeeState extends State<FormBodyEmployee> {
  // Declaración de valores para el FirebaseValueDropdownController
  String? selectedSection;
  //String? staticValue;


  /// Esta función cambia dinamicamente la colección seleccionada en el [FirebaseValueDropdownController]
  /// de [controllerPuesto] segun el valor del [controllerSection] para poder
  /// relacionarla con la colección en la base de datos correspondiente.
  String getCollectionForSection(String? section) {
    switch (section) {
      case 'Analista':
        return 'Analista';
      case 'Apoyo':
        return 'Apoyo';
      case 'Auxiliar':
        return 'Auxiliar';
      case 'Enlace':
        return 'Enlace';
      case 'Jefatura':
        return 'Jefatura';
      case 'Subdireccion':
        return 'Subdireccion';
      case 'Titular':
        return 'Titular';
      default:
        return 'Apoyo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título del formulario.
        Text(
          widget.title,
          style: TextStyle(
              fontSize: responsiveFontSize(context, 24),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        // Primera fila: Nombre del empleado y Area.
        Row(
          children: [
            Expanded(
                flex: 3,
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
                        controller: widget.nameController,
                        keyboardType: TextInputType.text),
                  ],
                )),
            const SizedBox(width: 20.0),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Area',
                      style: TextStyle(
                          fontSize: responsiveFontSize(context, 20),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    FirebaseValueDropdown(
                      controller: widget.controllerArea,
                      collection: 'Area',
                      field: 'NombreArea',
                      onChanged: (String value) {
                        widget.onChangedDropdownList;
                      },
                    )
                  ],
                )),
            const SizedBox(width: 20.0),
            Expanded(
                flex: 1,
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
                        items: widget.dropdownSex,
                        icon: const Icon(Icons.arrow_downward_rounded),
                        value: widget.sexDropdownValue,
                        onChanged: widget.onChangedDropdownList),
                  ],
                )),
          ],
        ),
        const SizedBox(height: 15.0),
        // Segunda fila: sección del empleado y Puesto.
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Sección',
                      style: TextStyle(
                          fontSize: responsiveFontSize(context, 20),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    FirebaseValueDropdown(
                      controller: widget.controllerSection,
                      collection: 'Secciones',
                      field: 'Seccion',
                      onChanged: (String value) {
                        setState(() {
                          selectedSection = value;
                        });
                        widget.onChangedFirebaseValue;
                      },
                    )
                  ],
                )),
            const SizedBox(width: 20.0),
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      'Puesto',
                      style: TextStyle(
                          fontSize: responsiveFontSize(context, 20),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    FirebaseValueDropdown(
                        controller: widget.controllerPuesto,
                        onChanged: (String value) {
                          widget.onChangedFirebaseValue;
                        },
                        collection: getCollectionForSection(selectedSection),
                        field: 'Nombre')
                  ],
                )),
          ],
        ),
        const SizedBox(height: 15.0),
        // Tercera fila: Ore del empleado y Sare.
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  'ORE',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                FirebaseDropdown(
                  controller: widget.controllerOre,
                  collection: 'Ore',
                  data: 'Ore',
                  textHint: 'Seleccione un Ore',
                )
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
                  controller: widget.controllerSare,
                  collection: 'Sare',
                  data: 'sare',
                  textHint: 'Seleccione SARE',
                  enabled: widget.controllerOre.selectedDocument == null,
                )
              ],
            )),
          ],
        ),
        const SizedBox(height: 15.0),
        // Cuarta fila: email del empleado.
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  'Correo',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                MyTextfileld(
                    hindText: 'Escriba un correo valido',
                    icon: const Icon(Icons.mail),
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress)
              ],
            )),
          ],
        ),
      ],
    );
  }
}
