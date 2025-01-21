import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/documents/dependenciesview.dart';
import 'package:testwithfirebase/pages/documents/firebaseservice.dart';



class TrimesterView extends StatefulWidget {
  const TrimesterView({Key? key}) : super(key: key);

  @override
  State<TrimesterView> createState() => _TrimesterViewState();
}

class _TrimesterViewState extends State<TrimesterView> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> trimesters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrimesters();
  }

  Future<void> _loadTrimesters() async {
    trimesters = await _firebaseService.getTrimesters();
    setState(() => isLoading = false);
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