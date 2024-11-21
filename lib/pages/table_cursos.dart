import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/my_table.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database_courses.dart';

import '../util/responsive.dart';

class TableCursos extends StatefulWidget {
  const TableCursos({super.key});

  @override
  State<TableCursos> createState() => _TableCursosState();
}

class _TableCursosState extends State<TableCursos> {
  final MethodsCourses methodsCourses = MethodsCourses();
  TextEditingController searchInput = TextEditingController();
  final List<String> headers = [
    "Nombre del Curso",
    "Fecha inicio curso",
    "Fecha de registro",
    "Fecha de envio de Constancia"
  ];
  final List<String> fieldKeys = [
    "NameCourse",
    "Fecharegistro",
    "FechaInicioCurso",
    "FechaenvioConstancia",
  ];

  bool viewInactivos = false; // Ver empleados inactivos
  bool isActive = true;
  Timer? _debounceTimer; // Timer para controlar el debounce
  List<Map<String, dynamic>> _filteredData = []; // Datos filtrados
  bool _isLoading = false; // Indica si está cargando datos

  Future<void> _searchCourses(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredData.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await methodsCourses.searchCoursesByName(query); // Método en tu base de datos
      setState(() {
        _filteredData = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancela el timer al salir
    searchInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("Lista de Cursos", style: TextStyle(
                            fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold
                        ),)),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: searchInput,
                        decoration: const InputDecoration(
                          hintText: "Escribe para buscar...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (_debounceTimer?.isActive ?? false) {
                            _debounceTimer!.cancel();
                          }
                          _debounceTimer = Timer(const Duration(milliseconds: 2000), () {
                            _searchCourses(value); // Llama a la búsqueda después del retraso
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Ink(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: greenColor,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            viewInactivos = !viewInactivos;
                            isActive = !isActive;
                          });
                        },
                        tooltip: viewInactivos
                            ? "Mostrar Cursos Inactivos"
                            : "Mostrar Cursos activos",
                        icon: Icon(
                          viewInactivos ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                _isLoading
                ? const Center(child: CircularProgressIndicator(),)
                    : FutureBuilder(
                    future: viewInactivos
                        ? methodsCourses.getAllCoursesInac()
                        : methodsCourses.getAllCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No courses found.'));
                      } else {
                        final data =
                            _filteredData.isEmpty ? snapshot.data! : _filteredData;
                        return MyTable(
                          headers: headers,
                          data: data,
                          fieldKeys: fieldKeys,
                          onEdit: (String id) {  },
                          onDelete: (String id) async {
                            try{
                              await methodsCourses.deleteCoursesDetail(id);
                              setState(() {});
                              showCustomSnackBar(context, "Curso eliminado correctamente", greenColor);
                            } catch (e) {
                              showCustomSnackBar(context, "Error: $e", Colors.red);
                            }
                          },
                          idKey: 'Id', onActive: isActive,
                          activateFunction: (String id) async {
                            try{
                              await methodsCourses.activateCoursesDetail(id);
                              setState(() {});
                              showCustomSnackBar(context, "Curso restaurado correctamente", greenColor);
                            } catch (e) {
                              showCustomSnackBar(context, "Error: $e", Colors.red);
                            }
                          },);
                      }
                    })
              ],
            )
          ),
        ),
      ),
    );
  }
}
