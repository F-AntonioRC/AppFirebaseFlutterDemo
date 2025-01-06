import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import '../../components/firebase_dropdown.dart';
import 'database.dart';

Future<void> addEmployee(BuildContext context,
    TextEditingController nameController,
    String? sexDropdownValue,
    FirebaseDropdownController controllerArea,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerDependency,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
  try {
    // Validaciones de los campos
    if (nameController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa un nombre", Colors.red);
      return;
    }

    if (sexDropdownValue == null || sexDropdownValue.isEmpty) {
      showCustomSnackBar(
          context, "Por favor, selecciona un sexo", Colors.red);
      return;
    }

    if (controllerDependency.selectedDocument == null) {
      showCustomSnackBar(
          context, "Por favor, selecciona una dependencia", Colors.red);
      return;
    }


    String id = randomAlphaNumeric(3);
    Map<String, dynamic> employeeInfoMap = {
      "IdEmployee": id,
      "Nombre": nameController.text,
      "Sexo": sexDropdownValue,
      "Estado": "Activo",
      "Area": controllerArea.selectedDocument?['NombreArea'],
      "IdArea": controllerArea.selectedDocument?['IdArea'],
      "IdSare": controllerSare.selectedDocument?['IdSare'],
      "Sare": controllerSare.selectedDocument?['sare'],
      "Dependencia":
      controllerDependency.selectedDocument?['NombreDependencia'],
      "IdDependencia": controllerDependency.selectedDocument?['IdDependencia'],
    };

    await DatabaseMethods().addEmployeeDetails(employeeInfoMap, id);

    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Empleado agregado correctamente",
        greenColor,
      );
    }
    // Limpiar y actualizar las entradas
    clearControllers();
    refreshData();
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}

Future<void> updateEmployee(BuildContext context,
    String documentId,
    TextEditingController nameController,
    String? sexDropdownValue,
    FirebaseDropdownController controllerArea,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerDependency,
    Map<String, dynamic>? initialData,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
  try {
    // Crear el mapa con los datos actualizados
    Map<String, dynamic> updateData = {
      'IdEmployee': documentId,
      'Nombre': nameController.text,
      'Sexo': sexDropdownValue.toString(),
      'IdArea':
      controllerArea.selectedDocument?['IdArea'] ?? initialData?['IdArea'],
      'IdSare':
      controllerSare.selectedDocument?['IdSare'] ?? initialData?['IdSare'],
      'IdDependencia':
      controllerDependency.selectedDocument?['IdDependencia'] ??
          initialData?['IdDependencia'],
      'Area': controllerArea.selectedDocument?['NombreArea'] ??
          initialData?['Area'],
      'Sare': controllerSare.selectedDocument?['sare'] ?? initialData?['Sare'],
      'Dependencia':
      controllerDependency.selectedDocument?['NombreDependencia'] ??
          initialData?['Dependencia'],
    };

    // Llamar al metodo del servicio para actualizar los datos
    await DatabaseMethods().updateEmployeeDetail(documentId, updateData);

    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Empleado actualizado correctamente",
        greenColor,
      );
    }
    clearControllers();
    refreshData();
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}