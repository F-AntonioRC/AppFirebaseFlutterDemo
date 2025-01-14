import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

class EmployeeFormLogic {
  final List<String> dropdownSex = ['M', 'F'];
  String? sexDropdownValue;
  String? valueFirebaseDropdown;

  final FirebaseValueDropdownController controllerSection = FirebaseValueDropdownController();
  final FirebaseValueDropdownController controllerArea = FirebaseValueDropdownController();
  final FirebaseValueDropdownController controllerPuesto = FirebaseValueDropdownController();

  final FirebaseDropdownController controllerOre =
      FirebaseDropdownController();
  final FirebaseDropdownController controllerSare =
      FirebaseDropdownController();

  final TextEditingController nameController = TextEditingController();

  bool isClearing = false;

  /// Limpia los controladores
  void clearControllers() {
    nameController.clear();
    sexDropdownValue = null;
    controllerOre.clearSelection();
    controllerSare.clearSelection();
    controllerSection.clearDocument();
    controllerPuesto.clearDocument();
    controllerArea.clearDocument();

  }

  /// Limpia los datos del proveedor
  void clearProviderData(BuildContext context) {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  /// Actualizar la vista
  void refreshProviderData(BuildContext context) {
    final provier = Provider.of<EditProvider>(context, listen: false);
    provier.refreshData();
  }

  /// Inicializa los controladores con datos del proveedor
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;

    if (provider.data != null) {
      nameController.text = provider.data?['Nombre'] ?? '';
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
        controllerPuesto.setValue(provider.data?['Puesto']);
      }
    }
  }
}
