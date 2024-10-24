import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/date_textflied.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database_courses.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  TextEditingController nameCourseController = new TextEditingController();
  TextEditingController nomenclaturaController = new TextEditingController();
  TextEditingController linkCourseController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController registroController = new TextEditingController();
  TextEditingController envioConstanciaController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Card(
          color: ligth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Añadir Curso", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Nombre del curso",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo obligatorio*",
                              icon: const Icon(
                                Icons.fact_check_sharp,
                                color: Colors.black,
                              ),
                              controller: nameCourseController,
                              obsecureText: false,
                              keyboardType: TextInputType.text),
                        ],
                      )),
                      const SizedBox(width: 20.0),
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Nomenclatura del Documento",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo Obligatorio*",
                              icon: const Icon(Icons.document_scanner_sharp,
                                  color: Colors.black),
                              controller: nomenclaturaController,
                              obsecureText: false,
                              keyboardType: TextInputType.text)
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Link del curso",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo obligatorio*",
                              icon: const Icon(Icons.link),
                              controller: linkCourseController,
                              obsecureText: false,
                              keyboardType: TextInputType.url),
                        ],
                      )),
                      const SizedBox(width: 20.0),
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Fecha de inicio del curso",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          DateTextField(controller: dateController),
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Fecha de registro",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          DateTextField(controller: registroController)
                        ],
                      )),
                      const SizedBox(width: 15.0),
                      Expanded(child: Column(
                        children: [
                          const Text(
                            "Fecha de envio de constancia",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          DateTextField(controller: envioConstanciaController),
                        ],
                      ),)
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                      child: MyButton(
                        text: 'Añadir',
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () async {
                          try {
                            String id = randomAlphaNumeric(3);
                            Map<String, dynamic> courseInfoMap = {
                              "Id": id,
                              "NameCourse": nameCourseController.text,
                              "LinkCourse": linkCourseController.text,
                              "FechaInicioCurso": dateController.text,
                              "Fecharegistro": registroController.text,
                              "FechaenvioConstancia": envioConstanciaController.text
                            };
                            await MethodsCourses().addCourse(courseInfoMap, id);
                            showCustomSnackBar(
                                context, "Curso añadido correctamente :D");

                          } catch (e) {
                            showCustomSnackBar(context, "Error: $e");
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
