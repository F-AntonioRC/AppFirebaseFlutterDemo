import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

import '../../components/firebase_dropdown.dart';
import 'database.dart';

Future<void> addEmployee(
    BuildContext context,
    TextEditingController nameController,
    String? sexDropdownValue,
    FirebaseDropdownController controllerArea,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerDependency,
    VoidCallback clearControllers,
    ) async {
  try {
    String id = randomAlphaNumeric(3);
    Map<String, dynamic> employeeInfoMap = {
      "IdEmployee": id,
      "Nombre": nameController.text,
      "Sexo": sexDropdownValue,
      "Estado": "Activo",
      "Area": controllerArea.selectedDocument?['NombreArea'],
      "IdArea": controllerArea.selectedDocument?['IdArea'],
      "IdSare": controllerSare.selectedDocument?['IdSare'],
      "Sare": controllerSare.selectedDocument?['Sare'],
      "Dependencia": controllerDependency.selectedDocument?['NombreDependencia'],
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
    // Limpiar las entradas
    clearControllers();
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}

Future<void> updateEmployee(
    BuildContext context,
    String documentId,
    TextEditingController nameController,
    String? sexDropdownValue,
    FirebaseDropdownController controllerArea,
    FirebaseDropdownController controllerSare,
    FirebaseDropdownController controllerDependency,
    Map<String, dynamic>? initialData,
    VoidCallback clearControllers,
    ) async {
  try {
    // Crear el mapa con los datos actualizados
    Map<String, dynamic> updateData = {
      'IdEmployee': documentId,
      'Nombre': nameController.text,
      'Sexo': sexDropdownValue,
      'IdArea': controllerArea.selectedDocument?['IdArea'] ??
          initialData?['IdArea'],
      'IdSare': controllerSare.selectedDocument?['IdSare'] ??
          initialData?['IdSare'],
      'IdDependencia': controllerDependency.selectedDocument?['IdDependencia'] ??
          initialData?['IdDependencia'],
      'Area': controllerArea.selectedDocument?['Area'] ??
          initialData?['Area'],
      'Sare': controllerSare.selectedDocument?['Sare'] ??
          initialData?['Sare'],
      'Dependencia': controllerDependency.selectedDocument?['Dependencia'] ??
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

    // Limpiar los controladores
    clearControllers();
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}