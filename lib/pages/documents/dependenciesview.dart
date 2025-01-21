import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/documents/coursesview.dart';
import 'package:testwithfirebase/pages/documents/firebaseservice.dart';

class DependenciesView extends StatefulWidget {
  final String trimester;
  const DependenciesView({Key? key, required this.trimester}) : super(key: key);

  @override
  State<DependenciesView> createState() => _DependenciesViewState();
}

class _DependenciesViewState extends State<DependenciesView> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> dependencies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDependencies();
  }

  Future<void> _loadDependencies() async {
    dependencies = await _firebaseService.getDependencies(widget.trimester);
    setState(() => isLoading = false);
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
                          //color: Colors.white,
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
