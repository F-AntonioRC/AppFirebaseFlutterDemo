import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/firebase_dropdown.dart';
import '../../providers/edit_provider.dart';

class EmployeeFormLogic {
  final List<String> dropdownSex = ['M', 'F'];
  String? sexDropdownValue;

  final FirebaseDropdownController controllerArea = FirebaseDropdownController();
  final FirebaseDropdownController controllerSare = FirebaseDropdownController();
  final FirebaseDropdownController controllerDependency = FirebaseDropdownController();

  final TextEditingController nameController = TextEditingController();

  bool isClearing = false;

  /// Limpia los controladores
  void clearControllers() {
    nameController.clear();
    sexDropdownValue = null;
    controllerArea.clearSelection();
    controllerSare.clearSelection();
    controllerDependency.clearSelection();
  }

  /// Limpia los datos del proveedor
  void clearProviderData(BuildContext context) {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  /// Inicializa los controladores con datos del proveedor
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;

    if (provider.data != null) {
      nameController.text = provider.data?['Nombre'] ?? '';
      sexDropdownValue = provider.data?['Sexo'] ?? '';

      if (provider.data?['Area'] != null) {
        controllerArea.setDocument({
          'Id': provider.data?['IdArea'],
          'Area': provider.data?['Area']
        });
      }
      if (provider.data?['Dependencia'] != null) {
        controllerDependency.setDocument({
          'Id': provider.data?['IdDependencia'],
          'Dependencia': provider.data?['Dependencia']
        });
      }
      if (provider.data?['Sare'] != null) {
        controllerSare.setDocument({
          'Id': provider.data?['IdSare'],
          'Sare': provider.data?['Sare']
        });
      }
    }
  }
}
