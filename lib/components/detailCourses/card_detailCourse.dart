import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/detailCourses/table_view_detailCourses.dart';
import 'package:testwithfirebase/components/header_search.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../formPatrts/custom_snackbar.dart';

class CardDetailCourse extends StatefulWidget {
  const CardDetailCourse({super.key});

  @override
  State<CardDetailCourse> createState() => _CardDetailcourseState();
}

class _CardDetailcourseState extends State<CardDetailCourse> {
  final MethodsDetailCourses methodsDetailCourses = MethodsDetailCourses();
  TextEditingController searchInput = TextEditingController();
  bool viewInactivos = false;
  bool isActive = true;
  Timer? _debounceTimer;
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos iniciales
  }

  Future<void> _loadData({String? query}) async {
    // Si el controlador está vacío y no hay una consulta proporcionada, salimos del metodo
    if (query == null || query.trim().isEmpty) {
      return;
    }

    try {
  setState(() => _isLoading = true);
  final results = await methodsDetailCourses.getDataSearchDetailCourse(
    courseName: query,
  );
  setState(() {
    _filteredData = results;
    print('Resultados filtrados: $_filteredData');
    _isLoading = false;
  });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showCustomSnackBar(context, "Error al cargar datos: $e", Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchInput.dispose();
    super.dispose();
  }
  Future<void> _searchDetalleCurso(String query) async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      await _loadData(query: query.isNotEmpty ? query : null);
    });
  }

  void refreshTable() {
    _loadData(); // Refresca la tabla al actualizar datos
  }

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(
        children: [
          HeaderSearch(
              searchInput: searchInput,
              onSearch: _searchDetalleCurso,
              onToggleView: () {
                setState(() {
                  viewInactivos = !viewInactivos;
                  isActive = !isActive;
                });
                _loadData();
              },
              viewInactivos: viewInactivos,
              title: "Cursos asignados",
              viewOn: "Mostrar inactivos",
              viewOff: "Mostrar activos"),
          const Divider(),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : TableViewDetailCourses(
                  viewInactivos: viewInactivos,
                  filteredData: _filteredData,
                  methodsDetailCourses: methodsDetailCourses,
                  isActive: isActive,
                  refreshTable: refreshTable)
        ],
      ),
    ));
  }
}
