import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/components/header_search.dart';
import '../custom_snackbar.dart';
import 'table_view_courses.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

class CardTableCourses extends StatefulWidget {
  const CardTableCourses({super.key});

  @override
  State<CardTableCourses> createState() => _CardTableState();
}

class _CardTableState extends State<CardTableCourses> {
  final MethodsCourses methodsCourses = MethodsCourses();
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

  Future<void> _searchCourses(String query) async {
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
        final results = await methodsCourses.searchCoursesByName(query);
        setState(() {
          _filteredData = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if(mounted) {
          showCustomSnackBar(context, "Error: $e", Colors.red);
        }
      }
    });
  }

  void _refreshTable() {
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
            onSearch: _searchCourses,
            onToggleView: () {
              setState(() {
                viewInactivos = !viewInactivos;
                isActive = !isActive;
              });
            },
            viewInactivos: viewInactivos,
            title: 'Lista de Cursos',
            viewOn: 'Mostrar cursos Inactivos', viewOff: 'Mostrar cursos Activos',
          ),
          const Divider(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TableViewCourses(
            viewInactivos: viewInactivos,
            filteredData: _filteredData,
            methodsCourses: methodsCourses,
            isActive: isActive,
            refreshTable: _refreshTable,
          ),
        ],
      ),
    ));
  }
}