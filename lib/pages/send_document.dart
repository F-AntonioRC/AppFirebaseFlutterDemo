import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class TrimestersView extends StatefulWidget { 
  const TrimestersView({Key? key}) : super(key: key);

  @override
  State<TrimestersView> createState() => _TrimestersViewState();
}
class _TrimestersViewState extends State<TrimestersView> {
  List<String> trimesters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrimesters();
  }

 /// The above Dart code is defining an asynchronous function `_loadTrimesters` that retrieves data from
 /// a Firestore collection named 'Cursos'. It queries the collection to get all documents and extracts
 /// unique trimesters from the retrieved data. It uses a `Set` to store unique trimester values and
 /// adds each trimester value to the set if it is not null.
  Future<void> _loadTrimesters() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('Cursos').get();

      // Extraemos los trimestres únicos
      Set<String> uniqueTrimesters = {};
      for (var doc in snapshot.docs) {
        String? trimester = doc['Trimestre'];
        if (trimester != null) {
          uniqueTrimesters.add(trimester);
        }
      }

      setState(() {
        trimesters = uniqueTrimesters.toList()..sort();
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar trimestres: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : trimesters.isEmpty
              ? const Center(child: Text('No hay trimestres disponibles.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: trimesters.length,
                    itemBuilder: (context, index) {
                      String trimester = trimesters[index];
                      return Material(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12), // Asegura el efecto de splash dentro del borde
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DependenciesView(
                                    trimester: trimester
                                  ),
                                ),
                              );
                            },
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
                                  child: Column(
                                    children: [
                                      Text(
                                        'Trimestre $trimester',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
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
class DependenciesView extends StatefulWidget {
  final String trimester;

  const DependenciesView({Key? key, required this.trimester}) : super(key: key);

  @override
  State<DependenciesView> createState() => _DependenciesViewState();
}

class _DependenciesViewState extends State<DependenciesView> {
  List<Map<String, dynamic>> dependencies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDependencies();
  }

  Future<void> _loadDependencies() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore
          .collection('Cursos')
          .where('Trimestre', isEqualTo: widget.trimester)
          .get();

      Set<String> uniqueDependencies = {};
      List<Map<String, dynamic>> loadedDependencies = [];

      for (var doc in snapshot.docs) {
        String idDependencia = doc['IdDependencia'];

        if (!uniqueDependencies.contains(idDependencia)) {
          uniqueDependencies.add(idDependencia);

          DocumentSnapshot dependenciaDoc = await firestore.collection('Dependencia').doc(idDependencia).get();
          if (dependenciaDoc.exists) {
            loadedDependencies.add({
              'IdDependencia': idDependencia,
              'NombreDependencia': dependenciaDoc['NombreDependencia'],
            });
          }
        }
      }

      setState(() {
        dependencies = loadedDependencies;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar dependencias: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) { 
  return Scaffold(
    appBar: AppBar(title: const Text('Dependencias')),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : dependencies.isEmpty
            ? const Center(child: Text('No hay dependencias disponibles.'))
            : Padding(
               padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 3 / 2, // Relación de aspecto
                  ),
                    itemCount: dependencies.length,
                    itemBuilder: (context, index) {
                      final dependencia = dependencies[index];
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12), // Asegura el efecto de splash dentro del borde
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CoursesView(
                                    trimester: widget.trimester,
                                    dependecyId: dependencia['IdDependencia'],
                                    dependencyName: dependencia['NombreDependencia'],
                                  ),
                                ),
                              );
                            },
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
                                  child: Column(
                                    children: [
                                      Text(
                                        dependencia['NombreDependencia'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
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
class CoursesView extends StatelessWidget {
  final String trimester;
  final String dependecyId;
  final String dependencyName;

  const CoursesView({
    Key? key,
    required this.trimester,
    required this.dependecyId,
    required this.dependencyName,
  }) : super(key: key);

  @override
 Widget build(BuildContext context) { 
  if (trimester == null || dependecyId == null) {
    return const Scaffold(
      body: Center(child: Text("Error: Trimestre o IdDependencia es nulo")),
    );
  }

  return Scaffold(
    appBar: AppBar(title: Text('Cursos de $dependencyName')),
    body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Cursos')
          .where('Trimestre', isEqualTo: trimester)
          .where('IdDependencia', isEqualTo: dependecyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay cursos disponibles."));
        }

        var courses = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 3 / 2, // Relación de aspecto
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var course = courses[index];
             

              // Verifica si los datos existen antes de usarlos
              String? courseName = course['NombreCurso'];
              String? dependency = course['Dependencia'];
              String? trimester = course['Trimestre'];
               print('Datos de los cursos: $courseName');
              if (courseName == null || dependency == null || trimester == null) {
                return const Center(
                  child: Text("Error: Datos del curso incompletos"),
                );
              }

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 5,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilesListPage(
                          courseName: courseName,
                          dependency: dependency,
                          trimester: trimester,
                        ),
                      ),
                    );
                  },
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
                          ],
                        ),
                      ), 
                    ], 
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}

}

class FilesListPage extends StatefulWidget {
  final String courseName; // Renombrado a courseName
  final String dependency;
  final String trimester;

  const FilesListPage({
    Key? key,
    required this.courseName,
    required this.dependency,
    required this.trimester,
  }) : super(key: key);

  @override
  State<FilesListPage> createState() => _FilesListPageState();
}

class _FilesListPageState extends State<FilesListPage> {
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
      ListResult coursesList = await storage.ref(
        '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/${widget.trimester}/${widget.dependency}/${widget.courseName}'
      ).listAll();

      Map<String, List<Map<String, String>>> loadedFiles = {};

      for (Reference courseRef in coursesList.items) {
        String url = await courseRef.getDownloadURL();
        loadedFiles[courseRef.name] = [{'name': courseRef.name, 'url': url}];
      }

      setState(() {
        courseFiles = loadedFiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener archivos: $e');
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
        title: Text('Archivos de ${widget.courseName}'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : courseFiles.isEmpty
              ? const Center(
                  child: Text('No hay archivos disponibles.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: courseFiles.length,
                  itemBuilder: (context, index) {
                    String fileName = courseFiles.keys.elementAt(index);
                    String fileUrl = courseFiles[fileName]!.first['url']!;

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
