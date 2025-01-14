import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import '../../components/dropdown_list.dart';
import '../../components/firebase_reusable/firebase_dropdown.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../components/firebase_reusable/firebase_value_dropdown.dart';
import '../../components/my_textfileld.dart';
import '../../util/responsive.dart';

class FormBodyEmployee extends StatefulWidget {
  final TextEditingController nameController;
  final FirebaseValueDropdownController controllerPuesto;
  final FirebaseValueDropdownController controllerArea;
  final FirebaseValueDropdownController controllerSection;
  final FirebaseDropdownController controllerSare;
  final FirebaseDropdownController controllerOre;
  final List<String> dropdownSex;
  final String? sexDropdownValue;
  final Function(String?)? onChangedDropdownList;
  final Function(String?)? onChangedFirebaseValue;
  final String title;

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
      required this.controllerOre, this.onChangedFirebaseValue});

  @override
  State<FormBodyEmployee> createState() => _FormBodyEmployeeState();
}

class _FormBodyEmployeeState extends State<FormBodyEmployee> {
  String? selectedSection;
  String? staticValue;
  // Define cómo mapear el valor de la sección a la colección correspondiente
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
          Text(
            widget.title,
            style: TextStyle(
                fontSize: responsiveFontSize(context, 24),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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
                        },)
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
          Row(
            children: [
              Expanded(
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
                      },)
                    ],
                  )),
              const SizedBox(width: 20.0),
              Expanded(
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
        ],
      );
    }
    }