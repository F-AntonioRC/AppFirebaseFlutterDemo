import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Map<String, dynamic>> cursosPendientes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarCursosPendientes();
  }

  Future<void> cargarCursosPendientes() async {
    try {
      // Obtener UID del usuario actual
      final userId = AuthService().getCurrentUserUid();
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener cursos pendientes
      final cursos = await obtenerCursosPendientes(userId);

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

 Future<List<Map<String, dynamic>>> obtenerCursosPendientes(String userId) async {
  try {
    // Obtener los IDs de los cursos completados
    final completadosSnapshot = await FirebaseFirestore.instance
        .collection('CursosCompletados')
        .where('uid', isEqualTo: userId)
        .get();

    final cursosCompletados = completadosSnapshot.docs
        .map((doc) => doc['IdCurso'])
        .toSet(); // Convertir a Set para búsquedas rápidas

    // Obtener los cursos asignados basados en el CUPO del usuario
    final employeeSnapshot = await FirebaseFirestore.instance
        .collection('Empleados')
        .where('CUPO', isEqualTo: widget.cupo)
        .get();

    if (employeeSnapshot.docs.isEmpty) {
      throw Exception('Empleado no encontrado');
    }

    final employeeData = employeeSnapshot.docs.first.data() as Map<String, dynamic>;
    final idOre = employeeData['IdOre'];
    final idSare = employeeData['IdSare'];

    if (idOre == null && idSare == null) {
      throw Exception('El empleado no tiene asignado un ORE ni un SARE.');
    }

    Query query = FirebaseFirestore.instance.collection('DetalleCursos');
    if (idOre != null) {
      query = query.where('IdOre', isEqualTo: idOre);
    }
    if (idSare != null) {
      query = query.where('IdSare', isEqualTo: idSare);
    }

    final detalleCursosSnapshot = await query.get();

    // Filtrar los IDs de cursos no completados
    final cursosPendientesId = detalleCursosSnapshot.docs
        .map((doc) => doc['IdCurso'])
        .where((idCurso) => idCurso != null && !cursosCompletados.contains(idCurso))
        .toList();

    print('Cursos asignados encontrados: ${detalleCursosSnapshot.docs.length}');
    print('Cursos pendientes encontrados: ${cursosPendientesId.length}');
    print('IDs de cursos pendientes: $cursosPendientesId');

    // Si no hay cursos pendientes, retorna una lista vacía
    if (cursosPendientesId.isEmpty) {
      return [];
    }

    // Obtener los datos de los cursos pendientes desde la colección 'Cursos'
    final cursosSnapshot = await FirebaseFirestore.instance
        .collection('Cursos')
        .where(FieldPath.documentId, whereIn: cursosPendientesId)
        .get();

    // Combinar los datos de los cursos con la información de la colección 'Cursos'
    final cursosPendientes = cursosSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    print('Cursos pendientes encontrados: $cursosPendientes');
    return cursosPendientes;
  } catch (e) {
    print('Error al obtener cursos pendientes: $e');
    return [];
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
