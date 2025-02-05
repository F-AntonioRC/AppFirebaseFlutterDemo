import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/employee/table_view_employee.dart';
import 'package:testwithfirebase/components/header_search.dart';
import 'package:testwithfirebase/service/employeeService/database_methods_employee.dart';
import '../formPatrts/custom_snackbar.dart';

// La clase `CardEmployee` es un StatefulWidget que administra la funcionalidad de 
//visualización y búsqueda de empleados en un formato de PaginatedTable.
class CardEmployee extends StatefulWidget {
  const CardEmployee({super.key});

  @override
  State<CardEmployee> createState() => _CardEmployeeState();
}

class _CardEmployeeState extends State<CardEmployee> {
  /// Estas líneas de código declaran variables de instancia dentro de la clase `_CardEmployeeState` en flutter.
  final DatabaseMethodsEmployee databaseMethods = DatabaseMethodsEmployee(); //Llama a los métodos en la clase DatabaseMethodsEmployee
  TextEditingController searchInput = TextEditingController(); //Controlador del campo de busqueda
  bool viewInactivos = false; //Variable para cambiar la vista de estado 'Activos' e 'Inactivos'
  bool isActive = true; //Valor asignado para la vista
  Timer? _debounceTimer; //Temporizador para la busqueda
  List<Map<String, dynamic>> _filteredData = [];  //Lista para mostrar los datos filtrados
  bool _isLoading = false; //Valor para visualizar los componentes dependiendo del estado

/// La función dispose cancela un temporizador debounced, elimina una entrada de búsqueda y llama 
/// al metodo dispose de la superclase.
  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchInput.dispose();
    super.dispose();
  }

/// Esta función Flutter `_searchEmployee` realiza una debounced search de empleados en función de una 
/// cadena de consulta, actualizando la interfaz de usuario con los resultados de la búsqueda y 
/// gestionando los errores.
/// 
/// Argumentos:
/// consulta (String): el parámetro `query` en la función `_searchEmployee` es una cadena que
/// representa la consulta de búsqueda de empleados. Esta consulta se utiliza para buscar empleados por 
/// nombre utilizando el metodo `searchCoursesByName`.
/// 
/// Retorna:
///   La función `_searchEmployee` returna un `Future<void>`.
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

/// La función `_refreshTable` actualiza la tabla cuando se actualizan los datos.
  void _refreshTable() {
    setState(() {}); // Refresca la tabla al actualizar datos
  }

/// Esta función de flutter crea un widget que muestra una lista de empleados con funcionalidad de búsqueda 
/// y la capacidad de alternar entre empleados activos e inactivos.
/// 
/// Argumentos:
/// contexto (BuildContext): el parámetro `context` en el metodo `build` de un widget de Flutter
/// representa la ubicación del widget en el árbol de widgets. Proporciona acceso a varias propiedades
/// y metodos relacionados con el contexto de compilación actual, como tema, localización y navegación.
/// 
/// Devuelve:
/// El metodo `build` está devolviendo un widget `BodyWidgets`, que contiene un widget `SingleChildScrollView`
/// como su elemento secundario. Dentro de `SingleChildScrollView`, hay un widget `Column` con varios 
/// elementos secundarios que incluyen un widget `HeaderSearch`, un widget `Divider` y una expresion 
/// condicional que representa un widget `CircularProgressIndicator` o un widget `TableViewEmployee` 
/// según el estado de la variable _isLoading.
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