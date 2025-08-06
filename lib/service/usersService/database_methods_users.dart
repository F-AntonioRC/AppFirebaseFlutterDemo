import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DatabaseMethodsUsers {

  Future<List<Map<String, dynamic>>> getDataUsers() async {
  final firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot userSnapshot = await firestore
        .collection('User')
        .orderBy('CUPO')
        .get();

    List<Map<String, dynamic>> users = [];

    for (var doc in userSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid'] as String? ?? '';
      final cupon = data['CUPO'] as String? ?? '';

      // Verificar si tiene cursos completados
      final cursoDoc = await firestore
          .collection('CursosCompletados')
          .doc(uid)
          .get();

      // Buscar si está registrado como empleado
      String empleadoNombre = 'No registrado';
      bool estaDadoDeAlta = false;

      if (cupon.isNotEmpty) {
        final empleadosSnapshot = await firestore
            .collection('Empleados')
            .where('CUPO', isEqualTo: cupon)
            .get();

        if (empleadosSnapshot.docs.isNotEmpty) {
          empleadoNombre = empleadosSnapshot.docs.first['Nombre'] as String? ?? 'No registrado';
          estaDadoDeAlta = true;
        }
      }

      users.add({
        ...data,
        'hasCompletedCourse': cursoDoc.exists,
        'empleadoNombre': empleadoNombre,
        'estaDadoDeAlta': estaDadoDeAlta,
      });
    }

    return users;
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

  Future<List<Map<String, dynamic>>> searchDataUsers({String? nombreEmpleadoBusqueda}) async {
  final firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot userSnapshot = await firestore
        .collection('User')
        .orderBy('CUPO')
        .get();

    List<Map<String, dynamic>> users = [];

    for (var doc in userSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final uid = data['uid'] as String? ?? '';
      final cupon = data['CUPO'] as String? ?? '';

      // Verificar si tiene cursos completados
      final cursoDoc = await firestore
          .collection('CursosCompletados')
          .doc(uid)
          .get();

      // Buscar si está registrado como empleado
      String empleadoNombre = 'No registrado';
      bool estaDadoDeAlta = false;

      if (cupon.isNotEmpty) {
        final empleadosSnapshot = await firestore
            .collection('Empleados')
            .where('CUPO', isEqualTo: cupon)
            .get();

        if (empleadosSnapshot.docs.isNotEmpty) {
          empleadoNombre = empleadosSnapshot.docs.first['Nombre'] as String? ?? 'No registrado';
          estaDadoDeAlta = true;
        }
      }

      final userMap = {
        ...data,
        'hasCompletedCourse': cursoDoc.exists,
        'empleadoNombre': empleadoNombre,
        'estaDadoDeAlta': estaDadoDeAlta,
      };

      // Si hay filtro, aplicarlo
      if (nombreEmpleadoBusqueda == null ||
          empleadoNombre.toLowerCase().contains(nombreEmpleadoBusqueda.toLowerCase())) {
        users.add(userMap);
      }
    }

    return users;
  } on FirebaseException catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('firebase_error_code', exception.code);
      },
    );
    rethrow;
  } catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    rethrow;
  }
}

  

  Future<void> deleteuser (String id) async {
        try {
final userRef = FirebaseFirestore.instance.collection('User').doc(id);
final cursoRef = FirebaseFirestore.instance.collection('CursosCompletados').doc(id);

final userDoc = await userRef.get();
if (userDoc.exists) await userRef.delete();

final cursoDoc = await cursoRef.get();
if (cursoDoc.exists) await cursoRef.delete();

    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('operation', 'deleteUser');
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