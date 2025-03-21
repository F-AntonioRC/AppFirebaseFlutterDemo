import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/documents/coursesview.dart';
import 'package:testwithfirebase/pages/documents/firebaseservice.dart';

class DependenciesView extends StatefulWidget {
  final String trimester;
  const DependenciesView({super.key, required this.trimester});

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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1; 
                      double aspectRatio = 1.5; 

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 2; 
                        aspectRatio = 2;
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 2; 
                        aspectRatio = 1.8;
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: dependencies.length,
                        itemBuilder: (context, index) {
                          final dependencia = dependencies[index];

                          return Material(
                            borderRadius: BorderRadius.circular(12),
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
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
                                        width: double.infinity,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        dependencia['NombreDependencia'],
                                        style: const TextStyle(
                                          fontSize: 18,
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
                      );
                    },
                  ),
                ),
    );
  }
}
