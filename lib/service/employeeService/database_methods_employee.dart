import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DatabaseMethodsEmployee {
  //AGREGAR UN NUEVO EMPLEADO
  Future<void> addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
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

  //OBTENER TODOS LOS EMPLEADOS ACTIVOS E INACTIVOS
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

  //ACTUALIZAR
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

  //ELIMINAR
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

  //ACTIVAR
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

  //BUSCAR UN EMPLEADO
  Future<List<Map<String, dynamic>>> searchEmployeesByName(String name) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Empleados')
          .where('Nombre', isGreaterThanOrEqualTo: name)
          .where('Nombre',
          isLessThan:
          '${name}z') // Para búsquedas "que empiezan con minuscula"
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

  //AGREGAR CUPO A UN EMPLEADO
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
}
