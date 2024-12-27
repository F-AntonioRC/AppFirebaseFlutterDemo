import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/components/detailCourses/table_view_detailCourses.dart';
import 'package:testwithfirebase/components/header_search.dart';
import 'package:testwithfirebase/service/database_detail_courses.dart';

import '../custom_snackbar.dart';

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
  void dispose() {
    _debounceTimer?.cancel();
    searchInput.dispose();
    super.dispose();
  }

  Future<void> _searchDetalleCurso(String query) async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 2000), () async {
      if (query.isEmpty) {
        setState(() {
          _filteredData.clear();
        });
        return;
      }
      try {
        setState(() => _isLoading = true);
        final results = await methodsDetailCourses.searchDeatilCoursesByName(query);
        setState(() {
          _filteredData = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if(context.mounted) {
          showCustomSnackBar(context, "Error: $e", Colors.red);
        }
      }
    });
  }

  void refreshTable() {
    setState(() {}); // Refresca la tabla al actualizar datos
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
              },
              viewInactivos: viewInactivos,
              title: "Cursos asignados", viewOn: "Mostrar inactivos", viewOff: "Mostrar activos"),
          const Divider(),
          _isLoading
              ? const Center(child: CircularProgressIndicator(),)
              : TableViewDetailCourses(
              viewInactivos: viewInactivos,
              filteredData: _filteredData,
              methodsDetailCourses: methodsDetailCourses,
              isActive: isActive, refreshTable: refreshTable)
        ],
      ),
    ));
  }
}
