import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/userNormal/serviceuser/firebase_service.dart';
import 'cursos_normal.dart';

class DynamicCourseSelectionPage extends StatefulWidget {
  final String cupo;

  const DynamicCourseSelectionPage({Key? key, required this.cupo}) : super(key: key);

  @override
  _DynamicCourseSelectionPageState createState() => _DynamicCourseSelectionPageState();
}

class _DynamicCourseSelectionPageState extends State<DynamicCourseSelectionPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> cursosPendientes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarCursosPendientes();
  }

  Future<void> cargarCursosPendientes() async {
    try {
      final userId = AuthService().getCurrentUserUid();
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final cursos = await _firebaseService.obtenerCursosPendientes(userId, widget.cupo);

      setState(() {
        cursosPendientes = cursos;
        isLoading = false;
      });

      if (cursos.isEmpty) {
        print('El usuario no tiene cursos pendientes.');
      }
    } catch (e) {
      print('Error al cargar cursos pendientes: $e');
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
          : cursosPendientes.isEmpty
              ? const Center(child: Text('No hay cursos pendientes.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: cursosPendientes.length,
                    itemBuilder: (context, index) {
                      final curso = cursosPendientes[index];
                      return CourseCard(
                        courseName: curso['NombreCurso'],
                        trimester: curso['Trimestre'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CursosNormal(
                                course: curso['NombreCurso'],
                                subCourse: null,
                                trimester: curso['Trimestre'],
                                dependecy: curso['Dependencia'],
                                idCurso: curso['IdCurso'],
                              ),
                            ),
                          );
                        },
                        imagePath: 'assets/images/logo.jpg',
                      );
                    },
                  ),
                ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final String trimester;
  final String? startDate;
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
