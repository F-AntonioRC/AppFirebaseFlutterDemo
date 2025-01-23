import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MethodsDetailCourses {
  //REGISTRAR UN DETALLE CURSO
  Future addDetailCourse(
      Map<String, dynamic> detailCourseInfoMap, String id) async {
try {
  return await FirebaseFirestore.instance
      .collection("DetalleCursos")
      .doc(id)
      .set(detailCourseInfoMap);
} on FirebaseException catch (exception, stackTrace) {
  // Maneja excepciones específicas de Firebase
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
    withScope: (scope) {
      scope.setTag('firebase_error_Add_Detail_Course', exception.code);
    },
  );
  rethrow; // Relanzar la excepción
} catch (exception, stackTrace) {
  // Maneja otras excepciones
  await Sentry.captureException(exception, stackTrace: stackTrace,
  withScope: (scope) {
    scope.setTag('Firebase_error_addDetailCourse', detailCourseInfoMap as String);
  }
  );
  rethrow;
}
  }

  //ACTUALIZAR
  Future<void> updateDetalleCursos(
      String id, Map<String, dynamic> updateData) async {
    try {
      await FirebaseFirestore.instance
          .collection('DetalleCursos')
          .doc(id)
          .update(updateData);
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_update_Detail_Courses', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('Firebase_error_updateDetalleCursos', id);
      });
      rethrow;
    }
  }

  //ELIMINAR
  Future deleteDetalleCursos(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
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
  Future activarDetalleCurso(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
      await documentReference.update({'Estado': 'Activo'});
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_Activate_Detail_Course', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('Firebase_error_activarDetalleCurso', id);
      }
      );
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> getDataDetailCourse(bool active) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot detalleCursosQuery = await firestore
          .collection('DetalleCursos')
          .where('Estado', isEqualTo: active ? 'Activo' : 'Inactivo')
          .get();

      if (detalleCursosQuery.docs.isEmpty) return [];

      List<Map<String, dynamic>> results = [];
      for (var detalleCursoDoc in detalleCursosQuery.docs) {
        String idCourse = detalleCursoDoc['IdCurso'];
        String? idOre = detalleCursoDoc['IdOre'];
        String? idSare = detalleCursoDoc['IdSare'];

        // Consulta usando funciones auxiliares
        var courseData = await firestore.collection('Cursos').doc(idCourse).get();
        var oreData = idOre != null
            ? await firestore.collection('Ore').doc(idOre).get()
            : null;
        var sareData = idSare != null
            ? await firestore.collection('Sare').doc(idSare).get()
            : null;

        results.add({
          'IdDetalleCurso': detalleCursoDoc.id,
          'NombreCurso': courseData.data()?['NombreCurso'] ?? 'N/A',
          'FechaInicioCurso': courseData.data()?['FechaInicioCurso'] ?? 'N/A',
          'FechaRegistro' : courseData.data()?['FechaRegistro'] ?? 'N/A',
          'FechaEnvioConstancia' : courseData.data()?['FechaEnvioConstancia'],
          'IdOre' : oreData?.data()?['IdOre'],
          'Ore': oreData?.data()?['Ore'] ?? 'N/A',
          'IdSare' : sareData?.data()?['IdSare'],
          'sare': sareData?.data()?['sare'] ?? 'N/A',
          'Estado': detalleCursoDoc['Estado'],
        });
      }

      return results;
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_getDetailCourse', exception.code);
        },
      );
      rethrow; // Relanzar la excepción
    } catch (exception, stackTrace) {
      // Maneja otras excepciones
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDataSearchDetailCourse({
    String? courseName,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Consulta inicial: Obtiene todos los documentos de DetalleCursos
      Query detalleCursosQuery = firestore.collection('DetalleCursos');
      QuerySnapshot detalleCursosSnapshot = await detalleCursosQuery.get();

      if (detalleCursosSnapshot.docs.isEmpty) return [];

      List<Map<String, dynamic>> results = [];

      for (var detalleCursoDoc in detalleCursosSnapshot.docs) {
        String idCourse = detalleCursoDoc['IdCurso'];
        String? idOre = detalleCursoDoc['IdOre'];
        String? idSare = detalleCursoDoc['IdSare'];

        // Consulta a Courses usando IdCourse
        var courseDoc = await firestore.collection('Cursos').doc(idCourse).get();

        // Filtra por NameCourse si se proporciona un nombre
        String? nameCourse = courseDoc.data()?['NombreCurso'];
        if (courseName != null &&
            courseName.isNotEmpty &&
            !(nameCourse?.toLowerCase().startsWith(courseName.toLowerCase()) ?? false)) {
          continue; // Salta este documento si no coincide
        }

        // Obtiene datos adicionales de Ore y Sare (si existen)
        var oreData = idOre != null
            ? await firestore.collection('Ore').doc(idOre).get()
            : null;
        var sareData = idSare != null
            ? await firestore.collection('Sare').doc(idSare).get()
            : null;

        // Combina los datos
        results.add({
          'IdDetalleCurso': detalleCursoDoc.id,
          'NombreCurso': nameCourse ?? 'N/A',
          'FechaInicioCurso': courseDoc.data()?['FechaInicioCurso'] ?? 'N/A',
          'FechaRegistro': courseDoc.data()?['FechaRegistro'] ?? 'N/A',
          'FechaEnvioConstancia': courseDoc.data()?['FechaEnvioConstancia'],
          'IdOre': oreData?.data()?['IdOre'],
          'Ore': oreData?.data()?['Ore'] ?? 'N/A',
          'IdSare': sareData?.data()?['IdSare'],
          'sare': sareData?.data()?['sare'] ?? 'N/A',
          'Estado': detalleCursoDoc['Estado'],
        });
      }

      return results;
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_getDataSearchDetailCourse', exception.code);
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
