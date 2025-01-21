import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/pages/documents/filesview.dart';
import 'package:testwithfirebase/pages/documents/firebaseservice.dart';

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
  final FirebaseService _firebaseService = FirebaseService();
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
                //color: Colors.white,
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
