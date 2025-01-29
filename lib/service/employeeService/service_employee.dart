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

/// La función `addEmployee` en flutter agrega un nuevo empleado a una base de datos con validación de 
/// entrada y manejo de errores.
/// 
/// Argumentos:
/// - contexto (BuildContext): El parámetro `BuildContext context` en la función `addEmployee` se usa
/// para proporcionar el contexto en el que se lleva a cabo la operación de adición de empleados. Este contexto es
/// generalmente necesario para tareas como mostrar cuadros de diálogo, barras de refrigerio o navegar a diferentes pantallas
/// dentro de la aplicación. Permite que la función interactúe con difentes elementos.
/// - nameController (TextEditingController): Un `TextEditingController` para capturar el nombre del 
/// empleado. Se utiliza para recuperar el texto ingresado en el campo de nombre en la IU donde el 
/// usuario ingresa el nombre del empleado.
/// - emailController (TextEditingController): El parámetro `emailController` en la función `addEmployee`
/// es un `TextEditingController` que se utiliza para controlar y recuperar el texto ingresado para el
/// campo de correo electrónico del empleado que se agrega. Le permite acceder y manipular el texto 
/// ingresado por el usuario en el campo de entrada de correo electrónico.
/// - controllerPuesto (FirebaseValueDropdownController): `FirebaseValueDropdownController` para
/// seleccionar el puesto o el cargo de un empleado de una lista desplegable que se completa desde 
/// Firebase.
/// - controllerArea (FirebaseValueDropdownController): el parámetro `controllerArea` en la
/// función `addEmployee` es un `FirebaseValueDropdownController` que se usa para administrar la
/// selección del menú desplegable para el área del empleado dentro de la organización. 
/// - controllerSection (FirebaseValueDropdownController): El parámetro `controllerSection` en la
/// función `addEmployee` es del tipo `FirebaseValueDropdownController`. Este controlador se usa para
/// administrar el valor seleccionado para la sección del empleado dentro de una lista desplegable. 
/// - sexDropdownValue (String): El parámetro `sexDropdownValue` en la función `addEmployee`
/// representa el valor seleccionado para el género o sexo del empleado que se agrega. Es una variable de tipo String
/// que contiene el valor seleccionado de un menú desplegable o campo de entrada que indica el género
/// del empleado (por ejemplo, "H", "M").
/// - controllerOre (FirebaseDropdownController): El parámetro `controllerOre` en la función `addEmployee`
/// es del tipo `FirebaseDropdownController`. Este controlador se utiliza para administrar la selección
/// del menú desplegable relacionada con el campo "Ore" para agregar un empleado. 
/// - controllerSare (FirebaseDropdownController): `FirebaseDropdownController` para seleccionar
/// valores de SARE de una colección de Firebase.
/// - clearControllers (VoidCallback): El parámetro `clearControllers` en la función `addEmployee` es
/// un tipo `VoidCallback`. Es una función que no toma ningún argumento y no devuelve ningún
/// valor. Se utiliza para borrar los controladores de texto o cualquier otro estado que deba ser
/// restablecido después
/// - refreshData (VoidCallback): El parámetro `refreshData` en la función `addEmployee` es un
/// tipo `VoidCallback`. Es una función que no toma ningún argumento y no devuelve ningún
/// valor. En este contexto, se utiliza para activar una acción de actualización después de agregar 
/// un empleado, para actualizar la interfaz de usuario.
/// 
/// Returna:
///   La función `addEmployee` returna un `Future<void>`.
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
    "Correo" : emailController.text.trim()
  };

  try {
    await DatabaseMethodsEmployee().addEmployeeDetails(employeeInfoMap, id);

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


/// La función `updateEmployee` en Dart actualiza los detalles de los empleados en una base de datos y maneja los informes de errores
/// mediante Firebase y Sentry.
/// 
/// Argumentos:
/// - context (BuildContext): El parámetro `context` en la función `updateEmployee` es de tipo
/// `BuildContext` y se utiliza para proporcionar el contexto en el que se realiza la operación de 
/// actualización. 
/// - documentId (String): El parámetro `documentId` es el identificador único del documento del empleado
/// en la base de datos que desea actualizar.
/// - nameController (TextEditingController): el parametro `nameController` es un `TextEditingController`
/// que se utiliza para controlar y recuperar la entrada de texto para el nombre del empleado.
/// - emailController (TextEditingController): `emailController` es un `TextEditingController` que
/// se utiliza para controlar y recuperar el texto ingresado para el campo de correo electrónico en 
/// el formulario de actualización de empleados.
/// - controllerPuesto (FirebaseValueDropdownController): El parámetro `controllerPuesto` en la
/// función `updateEmployee` es del tipo `FirebaseValueDropdownController`. Este controlador se usa para
/// administrar el estado de un widget desplegable que se completa con valores de Firebase. 
/// - controllerArea (FirebaseValueDropdownController): El parámetro `controllerArea` en la función 
/// `updateEmployee` es del tipo `FirebaseValueDropdownController`. 
/// - controllerSection (FirebaseValueDropdownController): El parámetro `controllerSection` en la
/// función `updateEmployee` es del tipo `FirebaseValueDropdownController`. Este controlador se utiliza para
/// administrar el valor seleccionado de una lista desplegable relacionada con la sección de un empleado. 
/// - sexDropdownValue (String): El parámetro `sexDropdownValue` en la función `updateEmployee` es una
/// cadena que representa el valor seleccionado para el género del empleado. Se utiliza para actualizar el
/// campo 'Sexo' en los datos del empleado con el valor de género seleccionado.
/// - controllerOre (FirebaseDropdownController): El parámetro `controllerOre` en la función 
/// `updateEmployee` es del tipo `FirebaseDropdownController`. Este controlador se utiliza para 
/// administrar la selección del menú desplegable para el campo "Ore" en los datos del empleado.
/// - controllerSare (FirebaseDropdownController): `FirebaseDropdownController` para seleccionar
/// valores de SARE de una colección de Firebase.
/// initialData (Map<String, dynamic>): El parámetro `initialData` en la función `updateEmployee`
/// es un mapa que contiene los datos iniciales del empleado que se está actualizando. Este mapa incluye
/// pares clave-valor que representan varios atributos del empleado, como su ID, nombre, correo electrónico, sexo,
/// puesto, sección, etc. Estos datos iniciales son mostrados en la UI para la edición mediante el formulario.
/// - clearControllers (VoidCallback): El parámetro `clearControllers` en la función `updateEmployee` es
/// un tipo `VoidCallback`. Es una función que no toma ningún argumento y no devuelve ningún
/// valor. Se utiliza para borrar los controladores de texto o cualquier otro estado que deba ser
/// restablecido después
/// - refreshData (VoidCallback): El parámetro `refreshData` en la función `updateEmployee` es un
/// tipo `VoidCallback`. Es una función que no toma ningún argumento y no devuelve ningún
/// valor. En este contexto, se utiliza para activar una acción de actualización después de agregar 
/// un empleado, para actualizar la interfaz de usuario.
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
        greenColor,
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

/// La función `assignCupo` asigna un cupo a un empleado en una aplicación Flutter, manejando 
/// excepciones de Firebase y reportando errores a Sentry.
///
/// Argumentos:
/// - context (BuildContext): El parámetro `context` en la función `assignCupo` es de tipo
/// `BuildContext` y se utiliza para proporcionar el contexto en el que se realiza la asignación de cupo.
/// - controllerCupo (TextEditingController): El parámetro `controllerCupo` es un
/// `TextEditingController` que se usa para controlar el texto que se edita en un campo de entrada. Le permite
/// recuperar el valor actual del texto, borrar el texto, establecer un texto nuevo y más. En este 
/// fragmento de código se usa para obtener el texto.
/// - idChange (String): El parámetro `idChange` en la función `assignCupo` es una variable String que
/// representa el identificador del empleado cuyo cupo se está asignando. Se utiliza para
/// identificar de forma única al empleado en la base de datos y realizar la operación de asignación de 
/// cupo específicamente para ese empleado.
/// - refreshTable (Función): El parámetro `refreshTable` en la función `assignCupo` es una función
/// que se pasa como argumento. Es una función de devolución de llamada que se llama después de que el cupo (cuota)
/// se asigna correctamente a un empleado. Esta función es responsable de actualizar la tabla o la interfaz de usuario para
/// reflejar los cambios.
Future<void> assignCupo(
    BuildContext context,
    TextEditingController controllerCupo,
    String idChange,
    Function refreshTable) async {
  try {
    await DatabaseMethodsEmployee.addEmployeeCupo(
        idChange, controllerCupo.text);
    if (context.mounted) {
      showCustomSnackBar(context, 'CUPO Asignado correctamente', greenColor);
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
/// Argumentos:
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

  if (controllerOre.selectedDocument == null &&
      controllerSare.selectedDocument == null) {
    errors.add("Por favor, selecciona un ORE o Sare");
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