import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/header_search.dart';
import '../formPatrts/custom_snackbar.dart';
import 'table_view_courses.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

// La clase `CardTableCourses` es un StatefulWidget que administra la funcionalidad de 
//visualización y búsqueda de cursos en un formato de PaginatedTable.
class CardTableCourses extends StatefulWidget {
  const CardTableCourses({super.key});

  @override
  State<CardTableCourses> createState() => _CardTableState();
}

class _CardTableState extends State<CardTableCourses> {
/// Estas líneas de código declaran variables de instancia dentro de la clase `_CardTableState` en flutter.
  final MethodsCourses methodsCourses = MethodsCourses(); //Llama a los métodos en la clase MethodsCourses
  TextEditingController searchInput = TextEditingController(); //Controlador del campo de busqueda
  bool viewInactivos = false; //Variable para cambiar la vista de estado 'Activos' e 'Inactivos'
  bool isActive = true; //Valor asignado para la vista
  Timer? _debounceTimer; //Temporizador para la busqueda
  List<Map<String, dynamic>> _filteredData = []; //Lista para mostrar los datos filtrados
  bool _isLoading = false; //Valor para visualizar los componentes dependiendo del estado

/// La función dispose cancela un temporizador debounced, elimina una entrada de búsqueda y llama 
/// al metodo dispose de la superclase.
  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchInput.dispose();
    super.dispose();
  }

/// Esta función Flutter `_searchCourses` realiza una debounced search de cursos en función de una 
/// cadena de consulta, actualizando la interfaz de usuario con los resultados de la búsqueda y 
/// gestionando los errores.
/// 
/// Argumentos:
/// consulta (String): el parámetro `query` en la función `_searchCourses` es una cadena que
/// representa la consulta de búsqueda de cursos. Esta consulta se utiliza para buscar cursos por 
/// nombre utilizando el método `searchCoursesByName`.
/// 
/// Retorna:
///   La función `_searchCourses` returna un `Future<void>`.
  Future<void> _searchCourses(String query) async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
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

/// La función `_refreshTable` actualiza la tabla cuando se actualizan los datos.
  void _refreshTable() {
    setState(() {}); // Refresca la tabla al actualizar datos
  }

/// Esta función de flutter crea un widget que muestra una lista de cursos con funcionalidad de búsqueda 
/// y la capacidad de alternar entre cursos activos e inactivos.
/// 
/// Argumentos:
/// contexto (BuildContext): el parámetro `context` en el método `build` de un widget de Flutter
/// representa la ubicación del widget en el árbol de widgets. Proporciona acceso a varias propiedades
/// y metodos relacionados con el contexto de compilación actual, como tema, localización y navegación.
/// 
/// Devuelve:
/// El metodo `build` está devolviendo un widget `BodyWidgets`, que contiene un widget `SingleChildScrollView`
/// como su elemento secundario. Dentro de `SingleChildScrollView`, hay un widget `Column` con varios 
/// elementos secundarios que incluyen un widget `HeaderSearch`, un widget `Divider` y una expresion 
/// condicional que representa un widget `CircularProgressIndicator` o un widget `TableViewCourses` 
/// según el estado de la variable _isLoading.
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