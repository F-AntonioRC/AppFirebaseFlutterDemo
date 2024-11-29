import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'cursos_normal.dart';

class CourseSelectionPage extends StatelessWidget {
  CourseSelectionPage({Key? key}) : super(key: key);

  // Lista de cursos disponibles
  final List<String> courses = ['SICAVISP', 'INMUJERES', 'CONAPRED'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Curso'),
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

            // GridView para mostrar las tarjetas de cursos
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de columnas en la cuadrícula
                  crossAxisSpacing: 16.0, // Espacio horizontal entre tarjetas
                  mainAxisSpacing: 16.0, // Espacio vertical entre tarjetas
                  childAspectRatio: 3 / 2, // Relación de aspecto de las tarjetas
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    courseName: courses[index],
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

  const CourseCard({Key? key, required this.courseName}) : super(key: key);

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
              builder: (context) => CursosNormal(course: courseName),
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
