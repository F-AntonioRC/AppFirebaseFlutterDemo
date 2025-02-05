import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// La clase `MethodsDetailCourses` contiene las funciones para realizar las diferentes operaciones
/// relacionadas con el manejo de los registros en la base de datos.

class MethodsDetailCourses {

/// La función `addDetailCourse` añade un nuevo documento a la colección de firestore, contiene
/// manejo de excepciones de Firebase y captura de las mismas con Sentry para el seguimiento de errores
///
/// Argumentos:
/// detailCourseInfoMap (Map<String, dynamic>): Un mapa con los datos para añadir
/// a la base de datos. Incluye parametros como IdCurso, IdOre, etc..
/// id (String): El parámetro `id` de la función `detailCourseInfoMap` se utiliza para especificar el
/// ID del documento con el que se almacenarán los detalles del curso asignado en la colección
/// "DetalleCursos" en Firestore. Identifica de forma única el documento del curso asignado que se
/// agrega.
/// Retorna:
///   La función `addDetailCourse` retorna un `Future<void>`.
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

/// La función `updateDetalleCursos` actualiza los detalles de los cursos asignados en la colección
/// de Firestore y maneja las excepciones de Firebase al capturarlas con Sentry.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `updateDetalleCursos` es el identificador único del
/// curso asignado cuyos datos desea actualizar en la base de datos de Firestore. Se utiliza para ubicar el
/// documento específico en la colección "DetalleCursos" que corresponde al curso asignado que desea actualizar.
/// updatedData (Map<String, dynamic>): El parámetro `updatedData` en la función `updateDetalleCursos`
/// es un tipo `Map<String, dynamic>` que contiene la información actualizada de un curso asignado.
/// Este mapa debe tener pares clave-valor donde las claves representan los campos que se actualizarán
/// en el documento del curso asignado y los valores representan los nuevos datos a actualizar.
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

/// La función `deleteDetalleCursos` elimina el detalle de un curso asignado actualizando su estado a
/// 'Inactivo' en la colección de Firestore, manejando excepciones de Firebase y capturándolas
/// con Sentry para seguimiento de errores.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `deleteDetalleCursos` es un identificador único para
/// el curso asignado cuyos detalles se eliminarán. Se utiliza para ubicar el documento específico en la
/// colección de cursos asignados de Firestore que se debe actualizar para establecer el campo 'Estado'
/// en 'Inactivo'.
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

/// La función `activarDetalleCurso` actualiza el campo 'Estado' de un documento de un curso asigando
/// en Firestore a 'Activo' y maneja las excepciones de Firebase capturándolas con Sentry.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `activarDetalleCurso` es un identificador único
/// para el curso asingnado cuyos detalles deben activarse. Esta función actualiza el campo 'Estado' del
/// documento del curso asignado en la colección 'DetalleCursos' en Firestore para cambiar el estado a 'Activo'.
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

/// La función `getDataDetailCourse` consulta la colección 'DetalleCursos' en Firestore y filtra los documentos
/// en función del campo 'Estado', comparándolo con el valor 'Activo' o 'Inactivo' según
/// el parámetro [active]. Para cada documento encontrado, realiza consultas adicionales a las
/// colecciones 'Cursos', 'Ore' y 'Sare' para obtener información relacionada (como el nombre,
/// fechas y otros identificadores). Los datos se combinan en un mapa y se agregan a la lista
/// de resultados.
///
/// En caso de error, se captura la excepción y se reporta a Sentry antes de relanzarla.
///
/// Parámetro:
/// - [active]: Booleano que indica si se desean obtener los cursos activos (`true`) o inactivos (`false`).
///
/// Retorna:
/// - Un [Future] que resuelve una lista de mapas, donde cada mapa contiene la información
///   combinada del detalle del curso y sus datos relacionados.
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
          'IdCurso' : courseData.data()?['IdCurso'],
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

/// La función `getDataSearchDetailCourse` consulta la colección 'DetalleCursos' en Firestore y, para cada documento,
/// consulta la colección 'Cursos' para obtener el campo 'NombreCurso'. Si se proporciona un valor
/// en [courseName], se filtra la información para incluir solo aquellos documentos cuyo nombre
/// comience con el valor proporcionado (ignorando mayúsculas y minúsculas). Además, consulta las colecciones
/// 'Ore' y 'Sare' para obtener datos relacionados (si existen). La información se combina en un mapa y se
/// añade a la lista de resultados.
///
/// En caso de error, se captura la excepción y se reporta a Sentry antes de relanzarla.
///
/// Parámetro:
/// - [courseName] (opcional): Cadena de texto que se utiliza para filtrar los cursos por nombre.
///
/// Retorna:
/// - Un [Future] que resuelve una lista de mapas, donde cada mapa contiene la información combinada
///   del detalle del curso y los datos relacionados.
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
