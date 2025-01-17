import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/employee/table_view_employee.dart';
import 'package:testwithfirebase/components/header_search.dart';
import 'package:testwithfirebase/service/employeeService/database.dart';

import '../formPatrts/custom_snackbar.dart';

class CardEmployee extends StatefulWidget {
  const CardEmployee({super.key});

  @override
  State<CardEmployee> createState() => _CardEmployeeState();
}

class _CardEmployeeState extends State<CardEmployee> {
  final DatabaseMethods databaseMethods = DatabaseMethods();
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

  Future<void> _searchEmployee(String query) async {
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
        final results = await databaseMethods.searchEmployeesByName(query);
        setState(() {
          _filteredData = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        showCustomSnackBar(context, "Error: $e", Colors.red);
      }
    });
  }

  void _refreshTable() {
    setState(() {}); // Refresca la tabla al actualizar datos
  }

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(body: SingleChildScrollView(
      child: Column(
        children: [
          HeaderSearch(
              searchInput: searchInput,
              onSearch: _searchEmployee,
              onToggleView: () {
                setState(() {
                  viewInactivos = !viewInactivos;
                  isActive = !isActive;
                });
              },
              viewInactivos: viewInactivos,
              title: "Lista de Empleados", viewOn: "Ver Empleados Inactivos",
              viewOff: "Ver Empleados Activos"),
          const Divider(),
          _isLoading
              ? const Center(child: CircularProgressIndicator(),)
              : TableViewEmployee(
              viewInactivos: viewInactivos,
              filteredData: _filteredData,
              databaseMethods: databaseMethods,
              isActive: isActive,
              refreshTable: _refreshTable)
        ],
      ),
    ));
  }
}