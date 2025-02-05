import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/detailCourses/table_view_detailCourses.dart';
import 'package:testwithfirebase/components/table/header_search.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../formPatrts/custom_snackbar.dart';

// La clase `CardDetailCourse` es un StatefulWidget que administra la funcionalidad de 
//visualización y búsqueda de cursos en un formato de PaginatedTable.
class CardDetailCourse extends StatefulWidget {
  const CardDetailCourse({super.key});

  @override
  State<CardDetailCourse> createState() => _CardDetailcourseState();
}

class _CardDetailcourseState extends State<CardDetailCourse> {
  /// Estas líneas de código declaran variables de instancia dentro de la clase `_CardDetailcourseState` en flutter.
  final MethodsDetailCourses methodsDetailCourses = MethodsDetailCourses(); //Llama a los métodos en la clase MethodsDetailCourses
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

/// Esta función Dart carga datos en funcion de una consulta, muestra indicadores de carga y 
/// maneja errores.
/// 
/// Argumentos:
/// consulta (String): La función `_loadData` es responsable de cargar datos en funcion de una
/// cadena de consulta proporcionada. Si la cadena de consulta está vacía o es nula, la función 
/// saldra antes. De lo contrario, establecerá el estado `_isLoading` en verdadero, obtendrá datos 
/// usando el metodo `getDataSearchDetailCourse` con la cadena de consulta proporcionada.
/// 
/// Retorna:
///   El metdod `_loadData` returns a `Future<void>`.
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
    _isLoading = false;
  });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showCustomSnackBar(context, "Error al cargar datos: $e", Colors.red);
      }
    }
  }

/// La función `_searchDetalleCurso` realiza una operación debounced para retrasar la ejecución 
/// de una consulta de búsqueda hasta que haya transcurrido una cierta cantidad de tiempo sin más 
/// entradas.
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

/// La función `_refreshTable` actualiza la tabla cuando se actualizan los datos.
  void refreshTable() {
    _loadData(); // Refresca la tabla al actualizar datos
  }

/// Esta función Flutter `_searchDetalleCurso` realiza una debounced search de detalle cursos en 
/// función de una  cadena de consulta, actualizando la interfaz de usuario con los resultados de 
/// la búsqueda y gestionando los errores.
/// 
/// Argumentos:
/// consulta (String): el parámetro `query` en la función `_searchDetalleCurso` es una cadena que
/// representa la consulta de búsqueda de detalle cursos. Esta consulta se utiliza para buscar 
/// cursos por nombre utilizando el metodo `getDataSearchDetailCourse`.
/// 
/// Retorna:
///   La función `_searchDetalleCurso` returna un `Future<void>`.
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
