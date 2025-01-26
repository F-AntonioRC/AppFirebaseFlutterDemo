import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

// La clase `DetailCourseFormLogic` contiene métodos para borrar controladores, actualizar datos 
//del provider, refrescar datos del provider e inicializar controladores con datos de un provider.
class DetailCourseFormLogic {
  final FirebaseDropdownController controllerOre = FirebaseDropdownController();
  final FirebaseDropdownController controllerSare = FirebaseDropdownController();
  final FirebaseDropdownController controllerCourses = FirebaseDropdownController();

  bool isClearing = false;

/// La función `clearControllers` borra los valores de varios controladores y menús desplegables en
/// la aplicación flutter.
  void clearControllers () {
    controllerOre.clearSelection();
    controllerSare.clearSelection();
    controllerCourses.clearSelection();
  }

/// La función `clearProviderData` borra los datos almacenados en un `EditProvider` usando el paquete 
/// Provider en flutter.
///   Contexto (BuildContext): El parámetro `context` en la función `clearProviderData` es del tipo
/// `BuildContext`. Se utiliza normalmente en Flutter para proporcionar información sobre la ubicación de un
/// widget dentro del árbol de widgets.
  void clearProviderData(BuildContext context) {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

/// La función `refreshProviderData` recupera una instancia de `EditProvider` usando el paquete Provider
/// en flutter y llama al método `refreshData` en él para actualizar la UI.
/// Contexto (BuildContext): El parámetro `context` en la función `refreshProviderData` es del tipo
/// `BuildContext`. Se utiliza normalmente en Flutter para proporcionar información sobre la ubicación de un
/// widget dentro del árbol de widgets.
  void refreshProviderData(BuildContext context) {
    final provier = Provider.of<EditProvider>(context, listen: false);
    provier.refreshData();
  }

/// Inicializa los controladores con datos del provider si existen.
/// 
/// Argumentos:
/// - contexto (BuildContext): El parámetro `context` en la función `initializeControllers` es
/// típicamente una referencia al BuildContext del widget donde se llama a la función. Le permite
/// acceder a información sobre el árbol de widgets y navegar a otros widgets en la
/// jerarquía. Este parámetro se usa para mostrar el provider (EditProvider): 
/// El parámetro `provider` en la función `initializeControllers` es una instancia de la clase 
/// `EditProvider`. Se usa para acceder a propiedades de datos como 'IdOre', 'Ore', 
/// 'IdSare', 'sare', 'IdCurso', 'NombreCurso'.
/// 
/// Retorna:
/// Si la condición `isClearing` es verdadera, la función `initializeControllers` retornará sin
/// ejecutar el resto del bloque de código.
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;

    if (provider.data != null) {

      if (provider.data?['IdOre'] != null) {
        controllerOre.setDocument({
          'Id': provider.data?['IdOre'],
          'Ore': provider.data?['Ore']
        });
      }
      if (provider.data?['IdCurso'] != null) {
        controllerCourses.setDocument({
          'Id': provider.data?['IdCurso'],
          'NombreCurso': provider.data?['NombreCurso']
        });
      }
      if (provider.data?['IdSare'] != null) {
        controllerSare.setDocument({
          'Id': provider.data?['IdSare'],
          'sare': provider.data?['sare']
        });
      }
    }
  }
}