import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/courses.dart';
import 'cursos_normal.dart';



class CourseSelectionPage extends StatelessWidget {
  CourseSelectionPage({Key? key}) : super(key: key);

  // Cursos principales con sus subcursos
  final Map<String, List<String>> courses = {
    'SICAVISP': ['Curso1', 'Curso2', 'Curso3'],
    'INMUJERES': ['Curso1', 'Curso2', 'Curso3'],
    'CONAPRED': ['Curso1', 'Curso2', 'Curso3'],
  };

  // Map de imágenes para cada curso
  final Map<String, String> courseImages = {
    'SICAVISP': 'assets/images/logo.jpg',
    'INMUJERES': 'assets/images/logo.jpg',
    'CONAPRED': 'assets/images/logo.jpg',
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
                    imagePath: courseImages[courseName] ?? 'assets/images/logo.jpg',
                    trimester: 'TRIMESTRE_1'
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
  final String imagePath; // Ruta de la imagen
  final String trimester;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.subCourses,
    required this.imagePath,
    required this.trimester,
    
  }) : super(key: key);

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
                trimester: 'TRIMESTRE 1',
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen en la parte superior
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Texto en la parte inferior
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Fecha de Inicio: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Nueva clase para seleccionar subcursos
class SubCourseSelectionPage extends StatelessWidget {
  final String courseName;
  final List<String> subCourses;
  final String trimester;

  const SubCourseSelectionPage({Key? key, required this.courseName, required this.subCourses, required this.trimester})
      : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccion $courseName'),
        backgroundColor: const Color(0xFF255946), // Cambia al color que uses.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas
            crossAxisSpacing: 16.0, // Espacio horizontal
            mainAxisSpacing: 16.0, // Espacio vertical
            childAspectRatio: 3 / 2, // Relación de aspecto
          ),
          itemCount: subCourses.length,
          itemBuilder: (context, index) {
            return SubCourseCard(
              courseName: courseName,
              subCourseName: subCourses[index],
              imageUrl: 'assets/images/logo.jpg',  // Ruta a tu imagen.
            );
          },
        ),
      ),
    );
  }
}

class SubCourseCard extends StatelessWidget {
  final String courseName;
  final String subCourseName;
  final String imageUrl;

  const SubCourseCard({
    Key? key,
    required this.courseName,
    required this.subCourseName,
    required this.imageUrl,
  }) : super(key: key);
  Future<String?> TrimesterSelectionDialog(BuildContext context) async {
  // Lista de opciones para los trimestres
  final List<String> trimesters = [
    'TRIMESTRE_1',
    'TRIMESTRE_2',
    'TRIMESTRE_3',
    'TRIMESTRE_4',
  ];
return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Selecciona un Trimestre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: trimesters.map((trimester) {
            return ListTile(
              title: Text(trimester),
              onTap: () {
                Navigator.pop(context, trimester); // Devuelve el trimestre seleccionado
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final selectedTrimester = await TrimesterSelectionDialog(context);

          if (selectedTrimester != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CursosNormal(
                  course: courseName,
                  subCourse: subCourseName,
                  trimester: selectedTrimester,
                ),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subCourseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Datos del curso",
                      style: TextStyle
(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}