import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

/// La clase `CourseFormLogic` contiene métodos y controladores para administrar datos de formularios 
/// e interactuar con Firebase en la aplicación Flutter.
class CourseFormLogic {
  final List<String> dropdowntrimestre = [
    '1',
    '2',
    '3',
    '4'
  ];
  String? trimestreValue;
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController nomenclaturaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController registroController = TextEditingController();
  TextEditingController envioConstanciaController = TextEditingController();
  FirebaseDropdownController controllerDependency = FirebaseDropdownController();

  bool isClearing = false;

/// La función `clearControllers` borra los valores de varios controladores y menús desplegables en
/// la aplicación flutter.
  void clearControllers() {
    nameCourseController.clear();
    nomenclaturaController.clear();
    trimestreValue = null;
    dateController.clear();
    registroController.clear();
    envioConstanciaController.clear();
    controllerDependency.clearSelection();
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
/// `EditProvider`. Se usa para acceder a propiedades de datos como 'NombreCurso', 'NomenclaturaCurso', 
/// 'Trimestre', 'FechaInicioCurso', 'FechaRegistro', 'FechaEnvioConstancia', 'Dependencia' 
///  e 'IdDependencia'.
/// 
/// Retorna:
/// Si la condición `isClearing` es verdadera, la función `initializeControllers` retornará sin
/// ejecutar el resto del bloque de código.
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;
    if (provider.data != null) {
      nameCourseController.text = provider.data?['NombreCurso'];
      nomenclaturaController.text = provider.data?['NomenclaturaCurso'];
      trimestreValue = provider.data?['Trimestre'];
      dateController.text = provider.data?['FechaInicioCurso'];
      registroController.text = provider.data?['FechaRegistro'];
      envioConstanciaController.text = provider.data?['FechaEnvioConstancia'];
      if (provider.data?['Dependencia'] != null) {
        controllerDependency.setDocument({
          'Id': provider.data?['IdDependencia'],
          'Dependencia': provider.data?['Dependencia']
        });
      }
    }
  }

}
