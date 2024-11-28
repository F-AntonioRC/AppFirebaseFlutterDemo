import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_dialog.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database_detail_courses.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {

  final MethodsDetailCourses databaseDetailCourses = MethodsDetailCourses();

  final FirebaseDropdownController _controllerSare =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerArea =
      FirebaseDropdownController();

  final FirebaseDropdownController _controllerCourse =
      FirebaseDropdownController();

  String? selectedCourse;
  String? selectedArea;
  String? selectedSare;
  String? idCourse;
  String? idArea;
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
                      "Asignar cursos",
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
                              controller: _controllerSare,
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

                    const SizedBox(height: 15.0),
                    MyButton(
                      text: "Agregar",
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          // Obtener el curso y área seleccionados y actualizar el estado
                          selectedCourse = _controllerCourse.selectedDocument?['NameCourse'] ?? 'Curso no seleccionado';
                          selectedArea = _controllerArea.selectedDocument?['Nombre'];
                          selectedSare = _controllerSare.selectedDocument?['sare'];
                          idCourse = _controllerCourse.selectedDocument?['IdCourse'] ?? "Id no encontrado";
                          idArea = _controllerArea.selectedDocument?['IdArea'] ?? "Id no encontrado";
                        });
                        showDialog(context: context,
                            builder: (BuildContext context) {
                          return CustomDialog(
                              dataOne: selectedCourse,
                              dataTwo: selectedArea ?? selectedSare,
                              accept: () async {
                            String id = randomAlpha(4);
                            Map<String, dynamic> detailCourseMap = {
                              "IdDetailCourse" : id,
                              "IdCourse": idCourse,
                              "IdArea": idArea,
                              "sare": selectedSare,
                              "Estado" : "Activo"
                            };
                            try{
                              await databaseDetailCourses.addDetailCourse(detailCourseMap, id);
                              if(context.mounted){
                                showCustomSnackBar(context, "¡Curso Asignado!", greenColor);
                              }
                            } catch (e) {
                              if(context.mounted){
                                showCustomSnackBar(context, "Error: $e", Colors.red);
                              }
                            }
                          });
                        });

                      }, buttonColor: greenColor,
                    ),
                    const SizedBox(height: 10.0)
                  ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}