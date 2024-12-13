import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:url_launcher/url_launcher.dart';

class SendDocument extends StatefulWidget {
  SendDocument({Key? key}) : super(key: key);

  @override
  State<SendDocument> createState() => _SendDocument();
}

class _SendDocument extends State<SendDocument> {
  Map<String, Map<String, List<Map<String, String>>>> courseFiles = {}; // Archivos por curso y subcurso
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilesForAllCourses();
  }

  // Cargar todos los archivos subidos en Firebase Storage
  Future<void> _loadFilesForAllCourses() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      // Cursos principales y sus subcursos
      Map<String, List<String>> courses = {
        'SICAVISP': ['Curso 1', 'Curso 2', 'Curso 3'],
        'INMUJERES': ['Curso 1', 'Curso 2', 'Curso 3'],
        'CONAPRED': ['Curso 1', 'Curso 2', 'Curso 3'],
      };

      Map<String, Map<String, List<Map<String, String>>>> loadedFiles = {};

      for (String course in courses.keys) {
        Map<String, List<Map<String, String>>> subcourseFiles = {};

        for (String subCourse in courses[course]!) {
          String subCoursePath =
              '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE\'S/Cursos_2024/TRIMESTRE 1/$course/$subCourse';
          Reference subCourseRef = storage.ref(subCoursePath);

          try {
            ListResult result = await subCourseRef.listAll();
            List<Map<String, String>> files = [];

            for (Reference ref in result.items) {
              String url = await ref.getDownloadURL();
              files.add({'name': ref.name, 'url': url});
            }

            subcourseFiles[subCourse] = files;
          } catch (e) {
            print('Error al cargar archivos de $subCourse: $e');
            subcourseFiles[subCourse] = [];
          }
        }

        loadedFiles[course] = subcourseFiles;
      }

      setState(() {
        courseFiles = loadedFiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar archivos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para descargar un archivo
  Future<void> _downloadFile(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'No se puede abrir el archivo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia de los cursos por Trimestre'),
        backgroundColor: greenColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courseFiles.isEmpty
              ? const Center(child: Text('No hay archivos disponibles.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: courseFiles.entries.map((entry) {
                      String courseName = entry.key;
                      Map<String, List<Map<String, String>>> subCourses =
                          entry.value;

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            courseName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          children: subCourses.entries.map((subEntry) {
                            String subCourseName = subEntry.key;
                            List<Map<String, String>> files = subEntry.value;

                            return Card(
                              elevation: 3,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ExpansionTile(
                                title: Text(
                                  subCourseName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 54, 54, 54),
                                  ),
                                ),
                                children: files.map((file) {
                                  return ListTile(
                                    title: Text(file['name'] ?? 'Archivo'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.download),
                                      onPressed: () =>
                                          _downloadFile(file['url']!),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
