import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/dialogChanges.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../components/my_table.dart';

class TableEmployee extends StatefulWidget {
  const TableEmployee({super.key});

  @override
  State<TableEmployee> createState() => _TableEmployeeState();
}

class _TableEmployeeState extends State<TableEmployee> {
  TextEditingController searchInput = TextEditingController();
  final DatabaseMethods databaseMethods = DatabaseMethods();
  final List<String> headers = ["Identificador", "CUPO", "Nombre Completo", "Estado", "Area", "Sare"];
  final List<String> fieldKeys = ["IdEmployee", "CUPO", "Nombre", "Estado", "Area", "Sare"];
  static const String idKey = "IdEmployee";

  bool viewInactivos = false; // Ver empleados inactivos
  bool isActive = true;
  Timer? _debounceTimer; // Timer para controlar el debounce
  List<Map<String, dynamic>> _filteredData = []; // Datos filtrados
  bool _isLoading = false; // Indica si está cargando datos

  Future<void> _searchEmployees(String query) async {
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
      final results = await databaseMethods.searchEmployeesByName(query); // Método en tu base de datos
      setState(() {
        _filteredData = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomSnackBar(context, "Error: $e", Colors.red);
      print(e);
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
      margin: const EdgeInsets.all(10.0),
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
                        child: Text("Lista de empleados", style: TextStyle(
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
                          _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
                            _searchEmployees(value); // Llama a la búsqueda después del retraso
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
                            ? "Mostrar Empleados Inactivos"
                            : "Mostrar Empleados activos",
                        icon: Icon(
                          viewInactivos ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0)
                  ],
                ),
                const Divider(),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FutureBuilder(
                  future: viewInactivos
                      ? databaseMethods.getEmployeeInact()
                      : databaseMethods.getEmployeeDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if ((!snapshot.hasData || snapshot.data!.isEmpty) &&
                        _filteredData.isEmpty) {
                      return const Center(child: Text('No employees found.'));
                    } else {
                      final data =
                      _filteredData.isEmpty ? snapshot.data! : _filteredData;
                      return MyTable(
                        headers: headers,
                        data: data,
                        fieldKeys: fieldKeys,
                        onEdit: (String id) {},
                        onDelete: (String id) async {
                          try {
                            await databaseMethods.deleteEmployeeDetail(id);
                            setState(() {});
                            showCustomSnackBar(
                                context, "Empleado eliminado Correctamente", greenColor);
                          } catch (e) {
                            showCustomSnackBar(context, "Error: $e", Colors.red);
                          }
                        },
                        onAssign: (String id) {
                          final selectedRow = data.firstWhere((row) => row[idKey] == id);
                          final name = selectedRow["Nombre"];
                          final idAdd = selectedRow[idKey];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogChanges(dataChange: name, idChange: idAdd,);
                            },
                          );
                        },
                        idKey: idKey,
                        onActive: isActive,
                        activateFunction: (String id) async {
                          try {
                            await databaseMethods.activateEmployeeDetail(id);
                            setState(() {});
                            showCustomSnackBar(
                                context, "Empleado restaurado Correctamente", greenColor);
                          } catch (e) {
                            showCustomSnackBar(context, "Error: $e", Colors.red);
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}