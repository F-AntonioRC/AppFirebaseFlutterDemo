import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/table/header_search.dart';
import 'package:testwithfirebase/pages/usersView/table_users.dart';
import 'package:testwithfirebase/service/usersService/database_methods_users.dart';

class CardUsers extends StatefulWidget {
  const CardUsers({super.key});

  @override
  State<CardUsers> createState() => _CardUsersState();
}

class _CardUsersState extends State<CardUsers> {
    /// Estas líneas de código declaran variables de instancia dentro de la clase `_CardUsersState` en flutter.
  final DatabaseMethodsUsers databaseMethodsUsers = DatabaseMethodsUsers(); //Llama a los métodos en la clase DatabaseMethodsUsers
  TextEditingController searchInput = TextEditingController(); //Controlador del campo de busqueda
  bool viewInactivos = false; //Variable para cambiar la vista de estado 'Activos' e 'Inactivos'
  bool isActive = true; //Valor asignado para la vista
  Timer? _debounceTimer; //Temporizador para la busqueda
  List<Map<String, dynamic>> _filteredData = []; //Lista para mostrar los datos filtrados
  bool _isLoading = false; //Valor para visualizar los componentes dependiendo del estado

  
  /// La función initState en flutter se utiliza para cargar datos iniciales 
/// cuando se inicializa un widget con estado.
  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos iniciales
  }

  ///   El metdod `_loadData` returns a `Future<void>`.
Future<void> _loadData({String? query}) async {
    // Si el controlador está vacío y no hay una consulta proporcionada, salimos del metodo
    if (query == null || query.trim().isEmpty) {
      return;
    }

    try {
  setState(() => _isLoading = true);
  final results = await DatabaseMethodsUsers().searchDataUsers(nombreEmpleadoBusqueda: query);
  setState(() {
    _filteredData = results;
    _isLoading = false;
  });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showCustomSnackBar(context, "Error al cargar datos: $e", Colors.red);
      }
    }
  }

/// La función `_searchUsers` realiza una operación debounced para retrasar la ejecución 
/// de una consulta de búsqueda hasta que haya transcurrido una cierta cantidad de tiempo sin más 
/// entradas.
  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchInput.dispose();
    super.dispose();
  }
  Future<void> _searchUsers(String query) async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      await _loadData(query: query.isNotEmpty ? query : null);
    });
  }

/// La función `_refreshTable` actualiza la tabla cuando se actualizan los datos.
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
            onSearch: _searchUsers, 
            onToggleView: () {}, 
            viewInactivos: viewInactivos, 
            title: 'Usuarios registrados en el Sistema', 
            viewOn: 'No permitido', 
            viewOff: 'No permitido'),
            const Divider(),
            _isLoading
            ? const Center(
            child: CircularProgressIndicator(),
            ) : TableUsers(filteredData: _filteredData, 
            databaseMethodsUsers: databaseMethodsUsers, 
            isActive: isActive, 
            refreshTable: _refreshTable)
        ],
      ),
    ));
  }
}