import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/card_preview.dart';
import 'package:testwithfirebase/components/dropdown_list.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final List<String> dropdownArea = [
    "Jefatura",
    "Analista",
    "Enlace",
    "Auxiliar"
  ];
  String? areaDropdownValue;

  final FirebaseDropdownController _controllerCourse =
      FirebaseDropdownController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Card(
              color: ligth,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column( children: [
                  const Text("Enviar Correos", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  const SizedBox(height: 10.0),
                  const Text('Curso',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  FirebaseDropdown(
                    controller: _controllerCourse,
                    collection: "Courses",
                    data: "NameCourse",
                    textHint: 'Seleccione un curso',
                  ),
                  const SizedBox(height: 10.0),
                  const Text('Area',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  DropdownList(
                    items: dropdownArea, icon: const Icon(Icons.arrow_downward_rounded), onChanged: (value) {
                    areaDropdownValue = value;
                  },),
                  const SizedBox(height: 10.0),
                  MyButton(text: "Previsualizar", icon: const Icon(Icons.remove_red_eye), onPressed: () {},)
                ]
                ),),)
          ],),
          const SizedBox(height: 10.0),
          const Text('Previsualización',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          const CardPreview(
            nameCourse: 'Telegram',
            nameDependency: 'Bienestar',
          )
        ],
      ),
    );
  }
}
