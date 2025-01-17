import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import 'database.dart';

Future<void> addEmployee(BuildContext context,
    TextEditingController nameController,
    FirebaseValueDropdownController controllerPuesto,
    FirebaseValueDropdownController controllerArea,
    FirebaseValueDropdownController controllerSection,
    String? sexDropdownValue,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerSare,
    VoidCallback clearControllers,
    VoidCallback refreshData
    ) async {
  try {
    // Validaciones de los campos
    if (nameController.text.isEmpty) {
      showCustomSnackBar(context, "Por favor, ingresa un nombre", Colors.red);
      return;
    }

    if(controllerArea.selectedValue == null) {
      showCustomSnackBar(
          context, "Por favor, selecciona un area", Colors.red);
      return;
    }

    if (sexDropdownValue == null || sexDropdownValue.isEmpty) {
      showCustomSnackBar(
          context, "Por favor, selecciona un sexo", Colors.red);
      return;
    }


    String id = randomAlphaNumeric(3);
    Map<String, dynamic> employeeInfoMap = {
      "IdEmployee": id,
      "Nombre": nameController.text,
      "Sexo": sexDropdownValue,
      "Estado": "Activo",
      "Area": controllerArea.selectedValue,
      "Sección" : controllerSection.selectedValue,
      "Puesto" : controllerPuesto.selectedValue,
      "IdSare": controllerSare.selectedDocument?['IdSare'],
      "Sare": controllerSare.selectedDocument?['sare'],
      "IdOre": controllerOre.selectedDocument?['IdOre'],
      "Ore": controllerOre.selectedDocument?['Ore'],
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
    FirebaseValueDropdownController controllerPuesto,
    FirebaseValueDropdownController controllerArea,
    FirebaseValueDropdownController controllerSection,
    String? sexDropdownValue,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerSare,
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
      'IdOre': controllerOre.selectedDocument?['IdOre'] ?? initialData?['IdOre'],
      'Ore': controllerOre.selectedDocument?['Ore'] ?? initialData?['Ore'],
      'IdSare': controllerSare.selectedDocument?['IdSare'] ?? initialData?['IdSare'],
      'Sare': controllerSare.selectedDocument?['sare'] ?? initialData?['Sare'],
      'Seccion' : controllerSection.selectedValue ?? initialData?['Seccion'],
      'Puesto' : controllerPuesto.selectedValue ?? initialData?['Puesto']
    };

    // Llamar al metodo del servicio para actualizar los datos
    await DatabaseMethods().updateEmployeeDetail(documentId, updateData);

    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Empleado actualizado correctamente",
        greenColor,
      );
      refreshData();
    }
    clearControllers();

  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}

Future<void> assignCupo (
    BuildContext context,
    FirebaseDropdownController controllerCupo,
    String idChange,
    Function refreshTable
    ) async {
  final String cupoSeleccionado = controllerCupo.selectedDocument?['CUPO'] ?? '';

  if(cupoSeleccionado.isNotEmpty) {
    try {
      await DatabaseMethods.addEmployeeCupo(idChange, cupoSeleccionado);
      if(context.mounted) {
        showCustomSnackBar(context, 'CUPO Asignado correctamente', greenColor);
        Navigator.pop(context);
        refreshTable();
      }
    } catch (e) {
      if(context.mounted) {
        showCustomSnackBar(context, "Error: $e", Colors.red);
      }
    }
  } else {
    showCustomSnackBar(context, "Por favor selecciona una CUPO", greenColor);
  }
}