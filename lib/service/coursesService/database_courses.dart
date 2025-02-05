import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// La clase `MethodsCourses` contiene las funciones para realizar las diferentes operaciones
/// relacionadas con el manejo de los registros en la base de datos.
class MethodsCourses {

/// La función `addCourse` añade un nuevo documento a la colección de firestore, contiene
/// manejo de excepciones de Firebase y captura de las mismas con Sentry para el seguimiento de errores.
///
/// Argumentos:
/// courseInfoMap (Map<String, dynamic>): Un mapa con los datos para añadir
/// a la base de datos. Incluye parametros como nombre del curso, trimestre, etc..
/// id (String): El parámetro `id` de la función `addCourse` se utiliza para especificar el
/// ID del documento con el que se almacenarán los detalles del empleado en la colección "Cursos" en
/// Firestore. Identifica de forma única el documento del empleado que se agrega.
/// Retorna:
///   La función `addCourse` retorna un `Future<void>`.
  Future<void> addCourse(Map<String, dynamic> courseInfoMap, String id) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Cursos')
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

/// La función `getDataCourses` recupera datos filtrados de empleados según su estado activo de
/// una colección de Firestore, manejando excepciones de Firebase y capturándolas con Sentry para
/// el seguimiento de errores.
///
/// Argumentos:
/// active (bool): El parámetro `active` en la función `getDataCourses` es un valor booleano que
/// determina si se deben filtrar los cursos activos o inactivos. Cuando `active` es `true`,
/// la función recuperará los cursos con el estado 'Activo', y cuando `active` es `false`,
/// recuperará los cursos con el estado.
///
/// Retorna:
/// La función `getDataCourses` retorna un `Future` que se resuelve en una `List` de `Map<String,
/// dynamic>`. Esta lista contiene los datos de los cursos que coinciden con el estado activo
/// especificado (ya sea'Activo' o 'Inactivo') de la colección de Firestore 'Cursos'.
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

/// La función `activateCoursesDetail` actualiza el campo 'Estado' de un documento de curso en
/// Firestore a 'Activo' y maneja las excepciones de Firebase capturándolas con Sentry.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `activateCoursesDetail` es un identificador único
/// para el curso cuyos detalles deben activarse. Esta función actualiza el campo 'Estado' del
/// documento del curso en la colección 'Cursos' en Firestore para cambiar el estado a'Activo'.
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

/// La función `updateCourse` actualiza los detalles de los cursos en la colección
/// de Firestore y maneja las excepciones de Firebase al capturarlas con Sentry.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `updateCourse` es el identificador único del
/// curso cuyos datos desea actualizar en la base de datos de Firestore. Se utiliza para ubicar el
/// documento específico en la colección "Cursos" que corresponde al curso que desea actualizar.
/// updatedData (Map<String, dynamic>): El parámetro `updatedData` en la función `updateCourse`
/// es un tipo `Map<String, dynamic>` que contiene la información actualizada de un curso. Este
/// mapa debe tener pares clave-valor donde las claves representan los campos que se actualizarán en
/// el documento del curso y los valores representan los nuevos datos a actualizar.
  Future<void> updateCourse(String id, Map<String, dynamic> updateData) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Cursos')
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

/// La función `deleteCoursesDetail` elimina el detalle de un curso actualizando su estado a
/// 'Inactivo' en la colección de Firestore, manejando excepciones de Firebase y capturándolas
/// con Sentry para seguimiento de errores.
///
/// Argumentos:
/// id (String): El parámetro `id` en la función `deleteCoursesDetail` es un identificador único para
/// el curso cuyos detalles se eliminarán. Se utiliza para ubicar el documento específico en la
/// colección de cursos de Firestore que se debe actualizar para establecer el campo 'Estado'
/// en 'Inactivo'.
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

/// La función `searchCoursesByName` busca cursos por nombre en la colección de Firestore,
/// maneja excepciones de Firebase y las captura con Sentry para el seguimiento de errores.
///
/// Argumentos:
/// name (String): La función `searchCoursesByName` es un metodo que busca cursos por nombre
/// en la colección de Firestore llamada 'Cursos'. Utiliza el parámetro de entrada `name` para
/// consultar cursos cuyos nombres sean mayores o iguales que el valor proporcionado.
///
/// Retorna:
/// La función `searchCoursesByName` retorna un `Future` que se resuelve en una `List` de `Map<String,
/// dynamic>`. Esta lista contiene los datos de los cursos cuyos nombres coinciden con los criterios
/// de búsqueda especificados en la función. La función consulta la base de datos de Firestore para
/// encontrar cursos cuyos nombres sean mayores o iguales que el nombre proporcionado y menores
/// que el nombre seguido de 'z' (para búsquedas que comienzan con minusculas).
  Future<List<Map<String, dynamic>>> searchCoursesByName(String name) async {
    try {
      // Establecer el valor de la busqueda en mayuscula
      String nameFinal = name.toUpperCase();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Cursos')
          .where('NombreCurso', isGreaterThanOrEqualTo: nameFinal)
          .where('NombreCurso',
          isLessThan:
          '${nameFinal}z') // Para búsquedas "que empiezan con minuscula"
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