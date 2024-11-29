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
  Map<String, List<Map<String, String>>> courseFiles = {}; // Archivos por curso
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

      // Define aquí las rutas de los cursos
      List<String> courses = ['SICAVISP', 'INMUJERES', 'CONAPRED'];

      Map<String, List<Map<String, String>>> loadedFiles = {};

      for (String course in courses) {
        Reference courseRef = storage.ref(
            '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE\'S/Cursos_2024/TRIMESTRE 1/$course');

        ListResult result = await courseRef.listAll();
        List<Map<String, String>> files = [];

        for (Reference ref in result.items) {
          String url = await ref.getDownloadURL();
          files.add({'name': ref.name, 'url': url});
        }

        loadedFiles[course] = files;
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
        title: const Text('Archivos Subidos por Usuarios'),
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
                      List<Map<String, String>> files = entry.value;

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
                          children: files.map((file) {
                            return ListTile(
                              title: Text(file['name'] ?? 'Archivo'),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () => _downloadFile(file['url']!),
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
