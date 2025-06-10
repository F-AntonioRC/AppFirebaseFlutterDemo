import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


/// La clase `DatabaseMethodsEmployee` contiene las funciones para realizar las diferentes operaciones
/// relacionadas con el manejo de los registros en la base de datos.
class DatabaseMethodsEmployee {

/// La función `addEmployeeDetails` añade un nuevo documento a la colección de firestore, contiene
/// manejo de excepciones de Firebase y captura de las mismas con Sentry para el seguimiento de errores
/// 
/// Argumentos:
/// employeeInfoMap (Map<String, dynamic>): Un mapa con los datos para añadir
/// a la base de datos. Incluye parametros como nombre, puesto, etc..
/// id (String): El parámetro `id` de la función `addEmployeeDetails` se utiliza para especificar el
/// ID del documento con el que se almacenarán los detalles del empleado en la colección "Empleados" en
/// Firestore. Identifica de forma única el documento del empleado que se agrega.
/// Retorna:
///   La función `addEmployeeDetails` retorna un `Future<void>`.
  Future<void> addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    //Ciclo de validación para la función
    try {
      return await FirebaseFirestore.instance
          .collection("Empleados")
          .doc(id)
          .set(employeeInfoMap);
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }


/// La función `getDataEmployee` recupera datos filtrados de empleados según su estado activo de
/// una colección de Firestore, manejando excepciones de Firebase y capturándolas con Sentry para 
/// el seguimiento de errores.
/// 
/// Argumentos:
/// active (bool): El parámetro `active` en la función `getDataEmployee` es un valor booleano que
/// determina si se deben filtrar los empleados activos o inactivos. Cuando `active` es `true`, 
/// la función recuperará los empleados con el estado 'Activo', y cuando `active` es `false`, 
/// recuperará los empleados con el estado
/// 
/// Retorna:
/// La función `getDataEmployee` retorna un `Future` que se resuelve en una `List` de `Map<String,
/// dynamic>`. Esta lista contiene los datos de los empleados que coinciden con el estado activo 
/// especificado (ya sea'Activo' o 'Inactivo') de la colección de Firestore 'Empleados'.
  Future<List<Map<String, dynamic>>> getDataEmployee(bool active) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Empleados')
          .where('Estado', isEqualTo: active ? 'Activo' : 'Inactivo')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

/// La función `updateEmployeeDetail` actualiza los detalles de los empleados en la colección 
/// de Firestore y maneja las excepciones de Firebase al capturarlas con Sentry.
/// 
/// Argumentos:
/// id (String): El parámetro `id` en la función `updateEmployeeDetail` es el identificador único del
/// empleado cuyos datos desea actualizar en la base de datos de Firestore. Se utiliza para ubicar el
/// documento específico en la colección "Empleados" que corresponde al empleado que desea actualizar.
/// updatedData (Map<String, dynamic>): El parámetro `updatedData` en la función `updateEmployeeDetail`
/// es un tipo `Map<String, dynamic>` que contiene la información actualizada de un empleado. Este
/// mapa debe tener pares clave-valor donde las claves representan los campos que se actualizarán en 
/// el documento del empleado y los valores representan los nuevos datos a actualizar.
  Future<void> updateEmployeeDetail(
      String id, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('Empleados')
          .doc(id)
          .update(updatedData);
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('operation', 'updateEmployeeDetail');
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

/// La función `deleteEmployeeDetail` elimina el detalle de un empleado actualizando su estado a
/// 'Inactivo' en la colección de Firestore, manejando excepciones de Firebase y capturándolas
/// con Sentry para seguimiento de errores.
/// 
/// Argumentos:
/// id (String): El parámetro `id` en la función `deleteEmployeeDetail` es un identificador único para
/// el empleado cuyos detalles se eliminarán. Se utiliza para ubicar el documento específico en la
/// colección de empleados de Firestore que se debe actualizar para establecer el campo 'Estado' 
/// en 'Inactivo'.
  Future deleteEmployeeDetail(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Empleados').doc(id);
      await documentReference.update({'Estado': 'Inactivo'});
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

/// La función `activateEmployeeDetail` actualiza el campo 'Estado' de un documento de empleado en
/// Firestore a 'Activo' y maneja las excepciones de Firebase capturándolas con Sentry.
/// 
/// Argumentos:
/// id (String): El parámetro `id` en la función `activateEmployeeDetail` es un identificador único
/// para el empleado cuyos detalles deben activarse. Esta función actualiza el campo 'Estado' del
/// documento del empleado en la colección 'Empleados' en Firestore para cambiar el estado a'Activo'.
  Future activateEmployeeDetail(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Empleados').doc(id);
      await documentReference.update({'Estado': 'Activo'});
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

/// La función `searchEmployeesByName` busca empleados por nombre en la colección de Firestore,
/// maneja excepciones de Firebase y las captura con Sentry para el seguimiento de errores.
/// 
/// Argumentos:
/// name (String): La función `searchEmployeesByName` es un metodo que busca empleados por nombre
/// en la colección de Firestore llamada 'Empleados'. Utiliza el parámetro de entrada `name` para
/// consultar empleados cuyos nombres sean mayores o iguales que el valor proporcionado.
/// 
/// Retorna:
/// La función `searchEmployeesByName` retorna un `Future` que se resuelve en una `List` de `Map<String,
/// dynamic>`. Esta lista contiene los datos de los empleados cuyos nombres coinciden con los criterios 
/// de búsqueda especificados en la función. La función consulta la base de datos de Firestore para
/// encontrar empleados cuyos nombres sean mayores o iguales que el nombre proporcionado y menores
/// que el nombre seguido de 'z' (para búsquedas que comienzan con minusculas).
  Future<List<Map<String, dynamic>>> searchEmployeesByName(String name) async {
    try {
      // Establecer el valor de la busqueda en mayuscula
      String nameFinal = name.toUpperCase();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Empleados')
          .where('Nombre', isGreaterThanOrEqualTo: nameFinal)
          .where('Nombre', isLessThan: '${nameFinal}z') // Limitar los resultados
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
    }

/// Esta función de Dart actualiza el campo 'CUPO' de un empleado específico en Firestore y maneja
/// las excepciones de Firebase al capturarlas con Sentry para el seguimiento de errores.
/// 
/// Argumentos:
/// employeeId (String): El parámetro `employeeId` es un `String` que representa el identificador único
/// del empleado cuyo cupo necesita actualizarse en la base de datos de Firestore.
/// cupo (String): La función `addEmployeeCupo` se utiliza para actualizar el campo 'CUPO' para un 
/// empleado específico en una colección de Firestore llamada 'Empleados'. La función toma dos
/// parámetros el Id del empleado (employeeId) y el cupo (valor para asignar).
  static Future<void> addEmployeeCupo(String employeeId, String cupo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Empleados')
          .doc(employeeId)
          .update({'CUPO': cupo});
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

/// Obtiene el valor del campo 'CUPO' de un empleado dado su ID.
///
/// Esta función busca en la colección 'Empleados' de Firestore el documento correspondiente 
/// al ID de empleado proporcionado y devuelve el valor de su campo 'CUPO' como un `String`,
/// si existe. Si el documento no existe o el campo no está presente, devuelve `null`.
///
/// En caso de error al interactuar con Firestore, captura las excepciones específicas de Firebase 
/// (`FirebaseException`) y las generales (`Exception`), registrándolas en Sentry para su 
/// seguimiento, y luego relanza la excepción.
///
/// Parámetros:
/// - [idEmpleado]: ID del documento del empleado a consultar.
///
/// Retorna:
/// - Un `Future<String?>` que contiene el valor del campo 'CUPO' si existe, o `null` si no.
///
/// Manejo de errores:
/// - En caso de error de Firebase (como permisos insuficientes o documento no encontrado),
///   se captura la excepción y se registra en Sentry con la etiqueta 'firebase_error_code'.
/// - Para cualquier otro error, se captura y se registra en Sentry.
///
/// Excepciones:
/// - Relanza cualquier excepción capturada para que el código que llame a esta función
///   pueda manejarla apropiadamente.

  Future<String?> obtenerCupoEmpleado(String idEmpleado) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('Empleados')
        .doc(idEmpleado)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      return data?['CUPO'] as String?;
    } else {
      
      return null;
    }
  } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
  } catch (exception, stackTrace) {
          // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
  }
}

/// Obtiene el ID de usuario (`uid`) asociado a un valor específico de 'CUPO'.
///
/// Esta función realiza una consulta en la colección 'User' de Firestore, buscando el primer 
/// documento cuyo campo 'CUPO' sea igual al valor especificado. Si se encuentra un documento 
/// coincidente, devuelve el valor del campo 'uid' como un `String`. Si no hay coincidencias, devuelve `null`.
///
/// Parámetros:
/// - [cupo]: El valor del campo 'CUPO' a buscar.
///
/// Retorna:
/// - Un `Future<String?>` que contiene el valor del campo 'uid' si se encuentra
///   un documento coincidente, o `null` si no.
///
/// Manejo de errores:
/// - En caso de error de Firebase (como permisos insuficientes o consulta incorrecta),
///   se captura la excepción y se registra en Sentry con la etiqueta 'firebase_error_code'.
/// - Para cualquier otro error, se captura y se registra en Sentry.
///
/// Excepciones:
/// - Relanza cualquier excepción capturada para que el código que llame a esta función
///   pueda manejarla adecuadamente.
Future<String?> obtenerUserIdPorCupo(String cupo) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('CUPO', isEqualTo: cupo)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return userData['uid'] as String?;
    } else {
      
      return null;
    }
  } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_code', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
  } catch (exception, stackTrace) {
          // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
  }
}




}
