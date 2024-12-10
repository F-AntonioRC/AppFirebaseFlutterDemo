import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'cursos_normal.dart';

class CourseSelectionPage extends StatelessWidget {
  CourseSelectionPage({Key? key}) : super(key: key);

  // Cursos principales con sus subcursos
  final Map<String, List<String>> courses = {
    'SICAVISP': ['Curso 1', 'Curso 2', 'Curso 3'],
    'INMUJERES': ['Curso 1', 'Curso 2', 'Curso 3'],
    'CONAPRED': ['Curso 1', 'Curso 2', 'Curso 3'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Curso Principal'),
        backgroundColor: greenColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vista general de los cursos disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20),

            // GridView para mostrar las tarjetas de cursos principales
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de columnas en la cuadrícula
                  crossAxisSpacing: 16.0, // Espacio horizontal entre tarjetas
                  mainAxisSpacing: 16.0, // Espacio vertical entre tarjetas
                  childAspectRatio: 3 / 2, // Relación de aspecto de las tarjetas
                ),
                itemCount: courses.keys.length,
                itemBuilder: (context, index) {
                  String courseName = courses.keys.elementAt(index);
                  return CourseCard(
                    courseName: courseName,
                    subCourses: courses[courseName]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final List<String> subCourses;

  const CourseCard({Key? key, required this.courseName, required this.subCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCourseSelectionPage(
                courseName: courseName,
                subCourses: subCourses,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [const Color(0xFF255946)!, const Color(0xFF255946)!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                courseName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.folder,
                size: 40,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nueva clase para seleccionar subcursos
class SubCourseSelectionPage extends StatelessWidget {
  final String courseName;
  final List<String> subCourses;

  const SubCourseSelectionPage({Key? key, required this.courseName, required this.subCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcursos de $courseName'),
        backgroundColor: greenColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: subCourses.length,
        itemBuilder: (context, index) {
          String subCourseName = subCourses[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(subCourseName),
              leading: const Icon(Icons.folder_open, color: Colors.blue),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CursosNormal(
                      course: courseName,
                      subCourse: subCourseName,
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
