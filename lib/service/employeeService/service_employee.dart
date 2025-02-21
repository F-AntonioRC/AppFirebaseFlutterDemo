import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../handle_error_sentry.dart';
import 'database_methods_employee.dart';

/// Agrega un nuevo empleado a la base de datos.
///
/// La función `addEmployee` recopila la información ingresada por el usuario a través de varios
/// controladores y un controlador para un desplegable (sexo). Valida que los campos requeridos no
/// estén vacíos y, en caso contrario, muestra un mensaje de error.
/// Si la validación es exitosa, genera un identificador aleatorio para el empleado, crea un mapa
/// con los datos del empleado y llama a [DatabaseMethodsEmployee] para agregar el empleado en la base
/// de datos. Al finalizar, muestra un mensaje de éxito, limpia los controladores y refresca la UI.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [nameController]: Controlador para el nombre del empleado.
/// - [emailController]: Controlador para el email del empleado.
/// - [controllerPuesto]: Controlador personalizado para el puesto del empleado.
/// - [controllerArea]: Controlador personalizado para el area del empleado.
/// - [controllerSection]: Controlador personalizado para la sección del empleado.
/// - [sexDropdownValue]: Valor seleccionado del sexo.
/// - [controllerOre]: Controlador personalizado para el Ore del empleado.
/// - [controllerSare]: Controlador personalizado para el Sare del empleado.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
///
/// En caso de errores, se capturan y reportan a Sentry y se muestra un mensaje de error.
Future<void> addEmployee(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    FirebaseValueDropdownController controllerPuesto,
    FirebaseValueDropdownController controllerArea,
    FirebaseValueDropdownController controllerSection,
    String? sexDropdownValue,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerSare,
    VoidCallback clearControllers,
    VoidCallback refreshData) async {
  final validationResult = validateFields(
      context: context,
      nameController: nameController,
      emailController: emailController,
      controllerPuesto: controllerPuesto,
      controllerArea: controllerArea,
      controllerSection: controllerSection,
      sexDropdownValue: sexDropdownValue,
      controllerOre: controllerOre,
      controllerSare: controllerSare);

  // Validación de los controladores.
  if (!validationResult.isValid) {
    return; // Detiene la ejecución si hay errores
  }

  // Generación de los Id's aleatorios.
  String id = randomAlphaNumeric(4);
  // Crea el mapa con la información del curso.
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
    "Correo" : emailController.text.trim()
  };

  try {
    // Intenta agregar el empleado a la base de datos.
    await DatabaseMethodsEmployee().addEmployeeDetails(employeeInfoMap, id);

    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Empleado agregado correctamente",
        greenColorLight,
      );
    }
    // Limpiar y actualizar las entradas
    clearControllers();
    refreshData();
  } on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
      handleError(
          context: context,
          exception: e,
          stackTrace: stackTrace,
          operation: 'Añadir empleado',
          customMessage: 'Error de Firebase: ${e.message}',
          contextData: {
            'IdEmpleado': id,
            'Datos: ': employeeInfoMap,
          });
    }
  } catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'addEmployee');
      },
    );
  }
}


/// Actualiza la información de un empleado existente en la base de datos.
///
/// La función `updateEmployee` toma la información actualizada del empleado desde varios controladores
/// y un controlador para un desplegable, construye un mapa con la información actualizada y
/// llama a [DatabaseMethodsEmployee] para actualizar el documento correspondiente en la base
/// de datos. Tras la actualización, se muestra un mensaje de éxito, se limpian los controladores y se
/// refrescan los datos.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [initialData]: Datos iniciales del empleado que se están editando (opcional).
/// - [documentId]: Identificador del documento del empleado a actualizar.
/// - [nameController]: Controlador para el nombre del empleado.
/// - [emailController]: Controlador para el email del empleado.
/// - [controllerPuesto]: Controlador personalizado para el puesto del empleado.
/// - [controllerArea]: Controlador personalizado para el area del empleado.
/// - [controllerSection]: Controlador personalizado para la sección del empleado.
/// - [sexDropdownValue]: Valor seleccionado del sexo.
/// - [controllerOre]: Controlador personalizado para el Ore del empleado.
/// - [controllerSare]: Controlador personalizado para el Sare del empleado.
/// - [clearControllers]: Callback para limpiar los controladores tras el registro.
/// - [refreshData]: Callback para refrescar la UI o los datos luego de agregar el curso.
Future<void> updateEmployee(
    BuildContext context,
    String documentId,
    TextEditingController nameController,
    TextEditingController emailController,
    FirebaseValueDropdownController controllerPuesto,
    FirebaseValueDropdownController controllerArea,
    FirebaseValueDropdownController controllerSection,
    String? sexDropdownValue,
    FirebaseDropdownController controllerOre,
    FirebaseDropdownController controllerSare,
    Map<String, dynamic>? initialData,
    VoidCallback clearControllers,
    VoidCallback refreshData) async {

    // Crear el mapa con los datos actualizados
    Map<String, dynamic> updateData = {
      'IdEmpleado': documentId,
      'Nombre': nameController.text.toUpperCase(),
      'Correo' : emailController.text,
      'Sexo': sexDropdownValue.toString(),
      'Area' : controllerArea.selectedValue ?? initialData?['Area'],
      'IdOre':
          controllerOre.selectedDocument?['IdOre'] ?? initialData?['IdOre'],
      'Ore': controllerOre.selectedDocument?['Ore'] ?? initialData?['Ore'],
      'IdSare':
          controllerSare.selectedDocument?['IdSare'] ?? initialData?['IdSare'],
      'Sare': controllerSare.selectedDocument?['sare'] ?? initialData?['Sare'],
      'Seccion': controllerSection.selectedValue ?? initialData?['Seccion'],
      'Puesto': controllerPuesto.selectedValue ?? initialData?['Puesto'],
    };

    try {
    // Llamar al metodo del servicio para actualizar los datos
    await DatabaseMethodsEmployee()
        .updateEmployeeDetail(documentId, updateData);

    if (context.mounted) {
      showCustomSnackBar(
        context,
        "Empleado actualizado correctamente",
        greenColorLight,
      );
      refreshData();
    }
    clearControllers();
  } on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
      handleError(
          context: context,
          exception: e,
          stackTrace: stackTrace,
          operation: 'Editar empleado',
          customMessage: 'Error de Firebase: ${e.message}',
          contextData: {
            'IdEmpleado': documentId,
            'Datos: ': updateData,
          });
    }
  } catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'updateEmployee');
      },
    );
  }
}

/// La función `assignCupo` asigna un cupo a un empleado en la aplicación, manejando
/// excepciones de Firebase y reportando errores a Sentry.
///
/// Parámetros:
/// - [context]: Contexto actual de la aplicación.
/// - [controllerCupo]: Datos registrados por el controlador para asignar el CUPO
/// - [idChange]: Identificador del documento del empleado a asignar CUPO.
/// - [refreshTable]: Callback para refrescar la UI o los datos luego de agregar el curso.
Future<void> assignCupo(
    BuildContext context,
    TextEditingController controllerCupo,
    String idChange,
    Function refreshTable) async {
  try {
    // Intentar actualiza la colección
    await DatabaseMethodsEmployee.addEmployeeCupo(
        idChange, controllerCupo.text);
    if (context.mounted) {
      showCustomSnackBar(context, 'CUPO Asignado correctamente', greenColorLight);
      Navigator.pop(context);
    }
    refreshTable();
  } on FirebaseException catch (e, stackTrace) {
    // Reporta el error a Sentry con contexto adicional
    if (context.mounted) {
      handleError(
          context: context,
          exception: e,
          stackTrace: stackTrace,
          operation: 'Asignar Cupo a empleado',
          customMessage: 'Error de Firebase: ${e.message}',
          contextData: {
            'IdEmpleado': idChange,
            'Datos: ': controllerCupo,
          });
    }
  } catch (e, stackTrace) {
    // Reporta otros errores genéricos a Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'addEmployeeCupo');
      },
    );
  }
}


/// La función `validateFields` verifica si hay campos vacíos y valores seleccionados en varios 
/// controladores y devuelve una lista de errores, si los hay, además de mostrar los errores 
/// con la función ´showCustomSnackBar´.
/// 
/// Parametros:
/// - context (BuildContext): El parametro `context` es requerido para acceder al BuildContext en Flutter,
/// es necesario para mostrar diversos elementos y mensajes en la UI.
/// - nameController (TextEditingController): El pametro `nameController` es un `TextEditingController`
///  usado para la validación del valor que tiene, procurando que no este vacio.
/// - emailController (TextEditingController): El parámetro `emailController` en la función `validateFields`
/// es del tipo `TextEditingController` y se utiliza para controlar el campo de texto para ingresar una
/// dirección de correo electrónico. Es necesario para la validación para garantizar que el
/// usuario ingrese una dirección de correo electrónico válida.
/// - controllerPuesto (FirebaseValueDropdownController): El parámetro `controllerPuesto` es de tipo
/// `FirebaseValueDropdownController?`, con una referencia a un objeto `FirebaseValueDropdownController`.
///  - controllerArea (FirebaseValueDropdownController): El parámetro `controllerArea` en la función
/// `validateFields` es del tipo `FirebaseValueDropdownController` y es obligatorio. Se utiliza
/// para administrar el valor seleccionado para el área desplegable en el proceso de validación del 
/// formulario. Si el valor seleccionado para el área desplegable es nulo, se agrega un mensaje de error.
/// - controllerSection (FirebaseValueDropdownController): El parámetro `controllerSection` en la función
/// `validateFields` es del tipo `FirebaseValueDropdownController?`, es un parámetro opcional que puede 
/// contener una referencia a un objeto `FirebaseValueDropdownController` o ser `null`. Este parámetro 
/// se utiliza para controlar la selección de un valor.
/// - sexDropdownValue (String): El parámetro `sexDropdownValue` es un valor de cadena obligatorio 
/// se utiliza en el proceso de validación para garantizar que se seleccione un género antes de continuar. 
/// Si el valor es nulo o está vacío, se agrega un mensaje de error.
/// - controllerOre (FirebaseDropdownController): El parametro `controllerOre` en la función `validateFields`
/// es de tipo`FirebaseDropdownController` y es requerido junto con el
/// - controllerSare (FirebaseDropdownController): El parámetro `controllerSare` en la
/// función `validateFields` es del tipo `FirebaseDropdownController` y es obligatorio. Se utiliza para
/// gestionar la selección de un documento en una lista desplegable.
/// 
/// Retorna:
/// La función `validateFields` retorna un objeto `ValidationResult`. Si se detectan errores de
/// validación durante el proceso de validación, la función devolverá un objeto `ValidationResult`
/// con un indicador `false` y una lista de mensajes de error. Si no hay errores, devolverá un
/// objeto `ValidationResult` con un indicador `true` y una lista vacía.
ValidationResult validateFields({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController emailController,
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

  if (controllerSare.selectedDocument == null) {
    errors.add("Por favor, selecciona una SARE");
  }

  if(emailController.text.isEmpty) {
    errors.add("Por favor escriba un correo");
  }

  if (errors.isNotEmpty) {
    // Muestra el primer error en pantalla
    showCustomSnackBar(context, errors.first, Colors.red);
    return ValidationResult(false, errors);
  }

  return ValidationResult(true, []);
}

// La clase ValidationResult se utiliza para manejar el resultado de las validaciones y contiene 
//información sobre la validez y los errores encontrados.
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult(this.isValid, this.errors);
}