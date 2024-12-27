import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:url_launcher/url_launcher.dart';

class TrimestersView extends StatefulWidget { 
  const TrimestersView({Key? key}) : super(key: key);

  @override
  State<TrimestersView> createState() => _TrimestersViewState();
}

class _TrimestersViewState extends State<TrimestersView> {
  final List<String> trimesters = [
    'TRIMESTRE 1',
    'TRIMESTRE 2',
    'TRIMESTRE 3',
    'TRIMESTRE 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia por Trimestres'),
        backgroundColor: greenColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 4 / 3, // Relación de aspecto más compacta
          ),
          itemCount: trimesters.length,
          itemBuilder: (context, index) {
            String trimester = trimesters[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendDocument(trimester: trimester),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        height: 100, // Altura fija más pequeña
                        width: double.infinity, // Ancho completo de la tarjeta
                        fit: BoxFit.cover, // La imagen se adapta sin distorsionarse
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          trimester,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class SendDocument extends StatefulWidget {
  final String trimester;

  const SendDocument({Key? key, required this.trimester}) : super(key: key);

  @override
  State<SendDocument> createState() => _SendDocumentState();
}



class _SendDocumentState extends State<SendDocument> {
  Map<String, Map<String, List<Map<String, String>>>> courseFiles = {};
  bool isLoading = true;
  
  get trimester => null;

  @override
  void initState() {
    super.initState();
    _loadFilesForAllCourses();
  }

  Future<void> _loadFilesForAllCourses() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
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
              '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE\'S/Cursos_2024/$trimester/$course/$subCourse';
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
      setState(() {
        isLoading = false;
      });
    }
  }

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
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2, // Relación de aspecto
                    ),
                    itemCount: courseFiles.entries.length,
                    itemBuilder: (context, courseIndex) {
                      String courseName = courseFiles.keys.elementAt(courseIndex);
                      Map<String, List<Map<String, String>>> subCourses =
                          courseFiles[courseName]!;

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
                                          builder: (context) => SubCourseGridPage(
                                            courseName: courseName,
                                            subCourses: subCourses,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Ver subcursos'),
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

class SubCourseGridPage extends StatelessWidget {
  final String courseName;
  final Map<String, List<Map<String, String>>> subCourses;

  const SubCourseGridPage({
    Key? key,
    required this.courseName,
    required this.subCourses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcursos de $courseName'),
        backgroundColor: greenColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 3 / 2,
          ),
          itemCount: subCourses.keys.length,
          itemBuilder: (context, subCourseIndex) {
            String subCourseName = subCourses.keys.elementAt(subCourseIndex);
            List<Map<String, String>> files = subCourses[subCourseName]!;

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                          subCourseName,
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
                        subCourseName: subCourseName,
                        files: files,
                      ),
                    ),
                  );// Lógica para mostrar los archivos de este subcurso
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
  final String subCourseName;
  final List<Map<String, String>> files;

  const FilesListPage({
    Key? key,
    required this.subCourseName,
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
        title: Text('Archivos de $subCourseName'),
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

