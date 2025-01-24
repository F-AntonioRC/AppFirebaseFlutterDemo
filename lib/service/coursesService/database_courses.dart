import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MethodsCourses {
  //REGISTRAR UN NUEVO CURSO
  Future addCourse(Map<String, dynamic> courseInfoMap, String id) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Cursos")
          .doc(id)
          .set(courseInfoMap);
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

  //OBTENER TODOS LOS CURSOS ACTIVOS E INACTIVOS
  Future<List<Map<String, dynamic>>> getDataCourses(bool active) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cursos')
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

  //ACTIVAR
  Future activateCoursesDetail(String id) async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Cursos').doc(id);
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

  //ACTULIZAR
  Future<void> updateCourse(String id, Map<String, dynamic> updateData) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Cursos")
          .doc(id)
          .update(updateData);
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

  //ELIMINAR
  Future deleteCoursesDetail(String id) async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Cursos').doc(id);
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

  //BUSCAR UN CURSO
  Future<List<Map<String, dynamic>>> searchCoursesByName(String name) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Cursos')
          .where('NombreCurso', isGreaterThanOrEqualTo: name)
          .where('NombreCurso',
          isLessThan:
          '${name}z') // Para búsquedas "que empiezan con minuscula"
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
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