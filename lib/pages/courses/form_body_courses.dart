import 'package:flutter/material.dart';
import '../../components/formPatrts/date_textflied.dart';
import '../../components/formPatrts/dropdown_list.dart';
import '../../components/firebase_reusable/firebase_dropdown.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../components/formPatrts/my_textfileld.dart';
import '../../util/responsive.dart';

class FormBodyCourses extends StatefulWidget {
  final String title;
  final FirebaseDropdownController controllerDependency;
  final TextEditingController nameCourseController;
  final TextEditingController nomenclaturaController;
  final List<String> dropdowntrimestre;
  final String? trimestreValue;
  final Function(String?)? onChangedDropdownList;
  final TextEditingController dateController;
  final TextEditingController registroController;
  final TextEditingController envioConstanciaController;

  const FormBodyCourses(
      {super.key,
      required this.title,
      required this.nameCourseController,
      required this.nomenclaturaController,
      required this.dropdowntrimestre,
      this.trimestreValue,
      this.onChangedDropdownList,
      required this.dateController,
      required this.registroController,
      required this.envioConstanciaController,
        required this.controllerDependency});

  @override
  State<FormBodyCourses> createState() => _FormBodyCoursesState();
}

class _FormBodyCoursesState extends State<FormBodyCourses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title,
            style: TextStyle(
                fontSize: responsiveFontSize(context, 24),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 10.0),
Row(
  children: [
    Expanded(child: Column(
      children: [
        Text(
          "Nombre del curso",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: responsiveFontSize(context, 20),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        MyTextfileld(
            hindText: "Campo obligatorio*",
            icon: const Icon(
              Icons.fact_check_sharp,
            ),
            controller: widget.nameCourseController,
            keyboardType: TextInputType.text),
      ],
    )),
    const SizedBox(width: 20.0,),
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
                controller: widget.controllerDependency,
                collection: 'Dependencia',
                data: 'NombreDependencia',
                textHint: 'Seleccione una opción', enabled: true,)
          ],
        )),
  ],
),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  "Nomenclatura del Documento",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                MyTextfileld(
                    hindText: "Campo Obligatorio*",
                    icon: const Icon(Icons.document_scanner_sharp),
                    controller: widget.nomenclaturaController,
                    keyboardType: TextInputType.text),
              ],
            )),
            const SizedBox(width: 20.0),
            Expanded(
                child: Column(
              children: [
                Text(
                  'Trimestre del curso',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownList(
                  items: widget.dropdowntrimestre,
                  icon: const Icon(Icons.arrow_downward_rounded),
                  value: widget.trimestreValue,
                  onChanged: widget.onChangedDropdownList,
                ),
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  "Inicio del curso",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DateTextField(controller: widget.dateController),
              ],
            )),
            const SizedBox(width: 10.0),
            Expanded(
                child: Column(
              children: [
                Text(
                  "Fecha de registro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DateTextField(controller: widget.registroController),
              ],
            )),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Envio de constancia",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: responsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  DateTextField(controller: widget.envioConstanciaController),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
