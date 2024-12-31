import 'package:flutter/material.dart';
import '../../components/date_textflied.dart';
import '../../components/dropdown_list.dart';
import '../../components/my_textfileld.dart';
import '../../util/responsive.dart';

class FormBodyCourses extends StatelessWidget {
  final String title;
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
      required this.envioConstanciaController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: responsiveFontSize(context, 24),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 10.0),
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
            controller: nameCourseController,
            keyboardType: TextInputType.text),
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
                    controller: nomenclaturaController,
                    keyboardType: TextInputType.text),
              ],
            )),
            const SizedBox(width: 10.0),
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
                  items: dropdowntrimestre,
                  icon: const Icon(Icons.arrow_downward_rounded),
                  value: trimestreValue,
                  onChanged: onChangedDropdownList,
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
                DateTextField(controller: dateController),
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
                DateTextField(controller: registroController),
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
                  DateTextField(controller: envioConstanciaController),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
