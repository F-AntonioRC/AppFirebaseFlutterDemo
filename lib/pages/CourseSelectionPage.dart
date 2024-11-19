import 'package:flutter/material.dart';
import 'ViewUploadedFilesPage.dart';
import 'send_document.dart';

class CourseSelectionPage extends StatelessWidget {
  CourseSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Curso'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para SICAVISP
            CourseButtons(
              courseName: 'SICAVISP',
            ),
            // Botón para INMUJERES
            CourseButtons(
              courseName: 'INMUJERES',
            ),
            // Botón para CONAPRED
            CourseButtons(
              courseName: 'CONAPRED',
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para generar los botones de cada curso dinámicamente
class CourseButtons extends StatelessWidget {
  final String courseName;

  const CourseButtons({Key? key, required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón para enviar documentos
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendDocument(course: courseName),
                ),
              );
            },
            child: Text('Enviar a $courseName'),
          ),
          const SizedBox(width: 16), // Espacio entre los botones
          // Botón para ver archivos subidos
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewUploadedFilesPage(courseName: courseName),
                ),
              );
            },
            child: Text('Ver $courseName'),
          ),
        ],
      ),
    );
  }
}
