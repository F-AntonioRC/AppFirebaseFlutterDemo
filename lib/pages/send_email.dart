import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/card_preview.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {

  final FirebaseDropdownController _controllerArea =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerCourse =
      FirebaseDropdownController();

  String? selectedCourse;
  String? selectedArea;
  String? idCourse;
  String? idArea;
  String? fechaInicio;
  String? fechaRegistro;
  String? fechaEnvio;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    const Text(
                      "Enviar Correos",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    const Text('Curso',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10.0),
                    FirebaseDropdown(
                      controller: _controllerCourse,
                      collection: "Courses",
                      data: "NameCourse",
                      textHint: 'Seleccione un curso',
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                      Expanded(child: Column(
                        children: [
                          const Text('SARE',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10.0),
                          FirebaseDropdown(
                              controller: _controllerArea,
                              collection: "Sare",
                              data: "sare",
                              textHint: "Seleccione una sare"),
                        ],
                      ),),
                        const SizedBox(width: 20.0),
                        Expanded(child: Column(
                          children: [
                            const Text('Area',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10.0),
                            FirebaseDropdown(
                                controller: _controllerArea,
                                collection: "Area",
                                data: "Nombre",
                                textHint: "Seleccione un Area"),
                          ],
                        ),)
                      ],
                    ),

                    const SizedBox(height: 10.0),
                    MyButton(
                      text: "Previsualizar",
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          // Obtener el curso y área seleccionados y actualizar el estado
                          selectedCourse = _controllerCourse.selectedDocument?['NameCourse'] ?? 'Curso no seleccionado';
                          selectedArea = _controllerArea.selectedDocument?['Nombre'] ?? 'Área no seleccionada';
                          idCourse = _controllerCourse.selectedDocument?['Id'] ?? "Id no encontrado";
                          idArea = _controllerArea.selectedDocument?['IdArea'] ?? "Id no encontrado";
                          fechaInicio = _controllerCourse.selectedDocument?['FechaInicioCurso'] ?? "Fecha no encontrada";
                          fechaRegistro = _controllerCourse.selectedDocument?['Fecharegistro'] ?? "Fecha no encontrada";
                          fechaEnvio = _controllerCourse.selectedDocument?['FechaenvioConstancia'] ?? "Fecha no encontrada";
                        });
                      }, buttonColor: greenColor,
                    )
                  ]),
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          const Text('Previsualización',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          CardPreview(
            nameCourse: selectedCourse,
            nameArea: selectedArea, idCourse: idCourse, idArea: idArea,
            fechaInicio: fechaInicio,
            fechaRegistro: fechaRegistro, fechaEnvio: fechaEnvio,
          )
        ],
      ),
    );
  }
}