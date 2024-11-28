import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/date_textflied.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database_courses.dart';
import 'package:testwithfirebase/util/responsive.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Añadir Curso", style: TextStyle(fontSize: responsiveFontSize(context, 24),
                      fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          Text(
                            "Nombre del curso",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo obligatorio*",
                              icon: const Icon(
                                Icons.fact_check_sharp,
                              ),
                              controller: nameCourseController,
                              keyboardType: TextInputType.text),
                        ],
                      )),
                      const SizedBox(width: 20.0),
                      Expanded(child: Column(
                        children: [
                          Text(
                            "Nomenclatura del Documento",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo Obligatorio*",
                              icon: const Icon(Icons.document_scanner_sharp),
                              controller: nomenclaturaController,
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
                          Text(
                            "Link del curso",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          MyTextfileld(
                              hindText: "Campo obligatorio*",
                              icon: const Icon(Icons.link),
                              controller: linkCourseController,
                              keyboardType: TextInputType.url),
                        ],
                      )),
                      const SizedBox(width: 20.0),
                      Expanded(child: Column(
                        children: [
                          Text(
                            "Fecha de inicio del curso",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
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
                          Text(
                            "Fecha de registro",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          DateTextField(controller: registroController)
                        ],
                      )),
                      const SizedBox(width: 15.0),
                      Expanded(child: Column(
                        children: [
                          Text(
                            "Fecha de envio de constancia",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
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
                        text: 'Agregar',
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () async {
                          try {
                            String id = randomAlphaNumeric(3);
                            Map<String, dynamic> courseInfoMap = {
                              "IdCourse": id,
                              "NameCourse": nameCourseController.text,
                              "LinkCourse": linkCourseController.text,
                              "FechaInicioCurso": dateController.text,
                              "Fecharegistro": registroController.text,
                              "FechaenvioConstancia": envioConstanciaController.text,
                              "Estado" : "Activo"
                            };
                            await MethodsCourses().addCourse(courseInfoMap, id);
                            if(context.mounted) {
                              showCustomSnackBar(context, "Curso añadido correctamente :D", greenColor);
                            }
                          } catch (e) {
                            if(context.mounted) {
                              showCustomSnackBar(context, "Error: $e", Colors.red);
                            }
                          }
                        }, buttonColor: greenColor,
                      )
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
