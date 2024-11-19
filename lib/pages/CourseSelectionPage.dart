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
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título principal
              const Text(
                'Seleccione un Curso',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30), // Espacio entre el título y los botones

              // Botones para los cursos
              CourseButtons(courseName: 'SICAVISP'),
              CourseButtons(courseName: 'INMUJERES'),
              CourseButtons(courseName: 'CONAPRED'),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseButtons extends StatelessWidget {
  final String courseName;

  const CourseButtons({Key? key, required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.deepPurple[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón para enviar documentos
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendDocument(course: courseName),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text('Enviar a $courseName'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Espacio entre los botones
              // Botón para ver archivos subidos
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewUploadedFilesPage(courseName: courseName),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: Text('Ver $courseName'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
