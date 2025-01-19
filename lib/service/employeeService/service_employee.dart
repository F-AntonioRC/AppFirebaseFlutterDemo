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
    VoidCallback refreshData) async {
  try {
    final validationResult = validateFields(context: context,
        nameController: nameController,
        controllerPuesto: controllerPuesto,
        controllerArea: controllerArea,
        controllerSection: controllerSection,
        sexDropdownValue: sexDropdownValue,
        controllerOre: controllerOre,
        controllerSare: controllerSare);

    if (!validationResult.isValid) {
      return; // Detiene la ejecución si hay errores
    }


    String id = randomAlphaNumeric(3);
    Map<String, dynamic> employeeInfoMap = {
      "IdEmpleado": id,
      "Nombre": nameController.text.toUpperCase(),
      "Sexo": sexDropdownValue,
      "Estado": "Activo",
      "Area": controllerArea.selectedValue,
      "Sección": controllerSection.selectedValue,
      "Puesto": controllerPuesto.selectedValue,
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
    VoidCallback refreshData) async {
  try {

    // Crear el mapa con los datos actualizados
    Map<String, dynamic> updateData = {
      'IdEmpleado': documentId,
      'Nombre': nameController.text.toUpperCase(),
      'Sexo': sexDropdownValue.toString(),
      'IdOre': controllerOre.selectedDocument?['IdOre'] ??
          initialData?['IdOre'],
      'Ore': controllerOre.selectedDocument?['Ore'] ?? initialData?['Ore'],
      'IdSare': controllerSare.selectedDocument?['IdSare'] ??
          initialData?['IdSare'],
      'Sare': controllerSare.selectedDocument?['sare'] ?? initialData?['Sare'],
      'Seccion': controllerSection.selectedValue ?? initialData?['Seccion'],
      'Puesto': controllerPuesto.selectedValue ?? initialData?['Puesto']
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

// Función para validar campos
ValidationResult validateFields({
  required BuildContext context,
  required TextEditingController nameController,
   FirebaseValueDropdownController? controllerPuesto,
  required FirebaseValueDropdownController controllerArea,
    FirebaseValueDropdownController? controllerSection,
  required String? sexDropdownValue,
  required FirebaseDropdownController controllerOre,
  required FirebaseDropdownController controllerSare,
}) {
  final List<String> errors = [];

  if (nameController.text.isEmpty) {
    errors.add("Por favor, ingresa un nombre");
  }

  if (controllerArea.selectedValue == null) {
    errors.add("Por favor, selecciona un área");
  }

  if (sexDropdownValue == null || sexDropdownValue.isEmpty) {
    errors.add("Por favor, selecciona un sexo");
  }

  if (controllerSection?.selectedValue == null) {
    errors.add("Por favor, elige una sección");
  }

  if (controllerPuesto?.selectedValue == null) {
    errors.add("Por favor, selecciona un puesto");
  }

  if (controllerOre.selectedDocument == null &&
      controllerSare.selectedDocument == null) {
    errors.add("Por favor, selecciona un ORE o Sare");
  }

  if (errors.isNotEmpty) {
    // Muestra el primer error en pantalla
    showCustomSnackBar(context, errors.first, Colors.red);
    return ValidationResult(false, errors);
  }

  return ValidationResult(true, []);
}

// Clase para manejar el resultado de validaciones
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult(this.isValid, this.errors);
}

Future<void> assignCupo(BuildContext context,
    TextEditingController controllerCupo,
    String idChange,
    Function refreshTable) async {

  try {

    await DatabaseMethods.addEmployeeCupo(idChange, controllerCupo.text);
    if (context.mounted) {
      showCustomSnackBar(context, 'CUPO Asignado correctamente', greenColor);
      Navigator.pop(context);
      refreshTable();
    }
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error: $e", Colors.red);
    }
  }
}