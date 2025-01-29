import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

/// La clase `EmployeeFormLogic` contiene métodos y controladores para administrar datos de formularios 
/// e interactuar con Firebase en la aplicación Flutter.
class EmployeeFormLogic {
  final List<String> dropdownSex = ['H', 'M'];
  String? sexDropdownValue;
  String? valueFirebaseDropdown;

  final FirebaseValueDropdownController controllerSection = FirebaseValueDropdownController(null);
  final FirebaseValueDropdownController controllerArea = FirebaseValueDropdownController(null);
  final FirebaseValueDropdownController controllerPuesto = FirebaseValueDropdownController(null);

  final FirebaseDropdownController controllerOre =
      FirebaseDropdownController();
  final FirebaseDropdownController controllerSare =
      FirebaseDropdownController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isClearing = false;

/// La función `clearControllers` borra los valores de varios controladores y menús desplegables en
/// la aplicación flutter.
  void clearControllers() {
    nameController.clear();
    sexDropdownValue = null;
    controllerOre.clearSelection();
    controllerSare.clearSelection();
    controllerSection.clearDocument();
    controllerPuesto.clearDocument();
    controllerArea.clearDocument();
    emailController.clear();
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
/// en flutter y llama al metodo `refreshData` en él  para actualizar la UI.
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
/// `EditProvider`. Se usa para acceder a propiedades de datos como 'Nombre','Correo', 'Sexo', 'Area', 
/// 'Ore', 'Sare', 'Seccion' y 'Puesto'.
/// 
/// Retorna:
/// Si la condición `isClearing` es verdadera, la función `initializeControllers` retornará sin
/// ejecutar el resto del bloque de código.
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;

    if (provider.data != null) {
      nameController.text = provider.data?['Nombre'] ?? '';
      emailController.text = provider.data?['Correo'] ?? '';
      sexDropdownValue = provider.data?['Sexo'] ?? '';

      if(provider.data?['Area'] != null) {
        controllerArea.setValue(provider.data?['Area']);
      }

      if (provider.data?['Ore'] != null) {
        controllerOre.setDocument(
            {'Id': provider.data?['IdOre'], 'Ore': provider.data?['Ore']});
      }
      if (provider.data?['Sare'] != null) {
        controllerSare.setDocument(
            {'Id': provider.data?['IdSare'], 'Sare': provider.data?['Sare']});
      }
      if(provider.data?['Seccion'] != null) {
        controllerSection.setValue(provider.data?['Seccion']);
      }
      if(provider.data?['Puesto'] != null) {
        controllerPuesto.setValue(provider.data?['Puesto']);
      }
    }
  }
}
