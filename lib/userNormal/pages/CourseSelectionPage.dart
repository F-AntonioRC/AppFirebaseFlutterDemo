import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'cursos_normal.dart';

class DynamicCourseSelectionPage extends StatefulWidget {
  final String cupo;

  const DynamicCourseSelectionPage({Key? key, required this.cupo})
      : super(key: key);

  @override
  _DynamicCourseSelectionPageState createState() =>
      _DynamicCourseSelectionPageState();
}

class _DynamicCourseSelectionPageState
    extends State<DynamicCourseSelectionPage> {

  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
  try {
    print('Obteniendo datos del empleado...');
    final employeeSnapshot = await FirebaseFirestore.instance
        .collection('Empleados')
        .where('CUPO', isEqualTo: widget.cupo)
        .get();

    if (employeeSnapshot.docs.isEmpty) {
      throw Exception('Empleado no encontrado');
    }

    final employeeData = employeeSnapshot.docs.first.data() as Map<String, dynamic>;
    print('Datos del empleado: $employeeData');

    final idOre = employeeData['IdOre'];
    final idSare = employeeData['IdSare'];

    if (idOre == null && idSare == null) {
      throw Exception('El empleado no tiene asignado un ORE ni un SARE.');
    }

    print('Obteniendo IDs de los cursos asignados...');
    Query query = FirebaseFirestore.instance.collection('DetalleCursos');

    // Filtrar por IdOre o IdSare según corresponda
    if (idOre != null) {
      query = query.where('IdOre', isEqualTo: idOre);
    }
    if (idSare != null) {
      query = query.where('IdSare', isEqualTo: idSare);
    }

    final detailCoursesSnapshot = await query.get();

    // Mapear y filtrar los datos para evitar errores
    final courseIds = detailCoursesSnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>; // Convertir a Map
          return data['IdCurso'];
        })
        .where((idCurso) => idCurso != null) // Filtrar valores nulos
        .toList();
    print('IDs de los cursos: $courseIds');

    // 3. Combinar con la información de cursos
    if (courseIds.isNotEmpty) {
      print('Obteniendo información de los cursos...');
      final coursesSnapshot = await FirebaseFirestore.instance
          .collection('Cursos')
          .where(FieldPath.documentId, whereIn: courseIds)
          .get();

      courses = coursesSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>) // Convertir a Map
          .toList();
    }

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('Error al cargar cursos: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    courseName: course['NombreCurso'],
                    trimester: course['Trimestre'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CursosNormal(
                            course: course['NombreCurso'],
                            subCourse: null, // Actualiza si hay subcursos
                            trimester: course['Trimestre'],
                            dependecy: course['Dependencia'], // Pasa la dependencia
                          ),
                        ),
                      );
                    },
                    imagePath: 'assets/images/logo.jpg',
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
  final String trimester;
  final String? startDate; // Nueva información
  final VoidCallback onTap;
  final String imagePath;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.trimester,
    this.startDate,
    required this.onTap,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                courseName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Trimestre: $trimester',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              if (startDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Inicio: $startDate',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
