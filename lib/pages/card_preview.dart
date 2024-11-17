import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class CardPreview extends StatefulWidget {
  final String? nameCourse;
  final String? nameArea;
  final String? idCourse;
  final String? idArea;
  final String? fechaInicio;
  final String? fechaRegistro;
  final String? fechaEnvio;

  // Constructor para recibir los datos
  const CardPreview({
    super.key,
    required this.nameCourse, // Recibe el valor de nameCourse
    required this.nameArea,
    required this.idCourse,
    required this.idArea, required this.fechaInicio, required this.fechaRegistro, required this.fechaEnvio,
  });

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: greenColor),
                  // Muestra los datos recibidos
                  title: Text('Nombre del curso: ${widget.nameCourse ?? "Curso not provided"} '),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Área: ${widget.nameArea ?? "No disponible"}'),
                      const SizedBox(height: 5.0),
                      Text('Fecha de Inicio: ${widget.fechaInicio ?? "No disponible"}'),
                      Text('Fecha de Registro: ${widget.fechaRegistro ?? "No disponible"}'),
                      Text('Fecha de Envío de Constancia: ${widget.fechaEnvio ?? "No disponible"}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                // TextField para que el usuario pueda escribir el mensaje
                const TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Escribe tu mensaje',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                MyButton(
                  text: "Enviar Correo",
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () {}, buttonColor: greenColor,
                ),
                const SizedBox(height: 10.0),
              ],
            ),),
        ),
      ),
    );
  }
}
