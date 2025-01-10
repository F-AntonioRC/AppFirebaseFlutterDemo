import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:url_launcher/url_launcher.dart';

class SendDocument extends StatefulWidget {
  final String trimester;

  const SendDocument({Key? key, required this.trimester}) : super(key: key);

  @override
  State<SendDocument> createState() => _SendDocumentState();
}

class _SendDocumentState extends State<SendDocument> {
  Map<String, List<Map<String, String>>> courseFiles = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilesForAllCourses();
  }

  Future<void> _loadFilesForAllCourses() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult coursesList = await storage.ref('2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/${widget.trimester}').listAll();

      Map<String, List<Map<String, String>>> loadedFiles = {};

      for (Reference courseRef in coursesList.prefixes) {
        String coursePath = courseRef.fullPath;
        ListResult filesList = await courseRef.listAll();
        List<Map<String, String>> files = [];

        for (Reference fileRef in filesList.items) {
          String url = await fileRef.getDownloadURL();
          files.add({'name': fileRef.name, 'url': url});
        }

        loadedFiles[courseRef.name] = files;
      }

      setState(() {
        courseFiles = loadedFiles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2, // Relación de aspecto
                    ),
                    itemCount: courseFiles.keys.length,
                    itemBuilder: (context, courseIndex) {
                      String courseName = courseFiles.keys.elementAt(courseIndex);
                      List<Map<String, String>> files = courseFiles[courseName]!;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  'assets/images/logo.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    courseName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FilesListPage(
                                            subCourseName: courseName,
                                            files: files,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Ver archivos'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class FilesListPage extends StatelessWidget {
  final String subCourseName; // Renombrado a courseName
  final List<Map<String, String>> files;

  const FilesListPage({
    Key? key,
    required this.subCourseName, // Renombrado a courseName
    required this.files,
  }) : super(key: key);

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
        title: Text('Archivos de $subCourseName'), // Renombrado a courseName
        backgroundColor: greenColor,
      ),
      body: files.isEmpty
          ? const Center(
              child: Text('No hay archivos disponibles.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: files.length,
              itemBuilder: (context, index) {
                String fileName = files[index]['name']!;
                String fileUrl = files[index]['url']!;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(
                      fileName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadFile(fileUrl),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
