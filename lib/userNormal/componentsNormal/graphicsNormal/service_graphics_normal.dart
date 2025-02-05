import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../graphics/model_chart.dart';

Future<List<ChartData>> getCompletedCoursesByUser() async {
  try {
    // Obtiene el UID del usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Sentry.captureMessage('Error_getCompletedCoursesByUser_User');
      throw Exception("Usuario no autenticado");
    }
    String userUID = user.uid;

    // Obtiene los documentos de la colección 'CursosCompletados' filtrados por el UID del usuario
    final snapshot = await FirebaseFirestore.instance
        .collection('CursosCompletados')
        .where('uid', isEqualTo: userUID)
        .get();

    if (snapshot.docs.isEmpty) {
      return []; // No hay cursos completados para este usuario
    }

    // Mapa para contar la cantidad de veces que aparece cada curso
    final Map<String, int> datosAgrupados = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      List<dynamic> cursosIds = data['IdCurso'] ?? [];

      for (String cursoId in cursosIds) {
        datosAgrupados[cursoId] = (datosAgrupados[cursoId] ?? 0) + 1;
      }
    }

    // Se convierte el mapa agrupado en una lista de ChartData
    return datosAgrupados.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();
  } on FirebaseException catch (exception, stackTrace) {
    // Captura y envía la excepción específica de Firebase a Sentry.
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('firebase_error_graphic', exception.code);
      },
    );
    rethrow; // Relanza la excepción para ser manejada aguas arriba.
  } catch (exception, stackTrace) {
    // Captura y envía cualquier otra excepción a Sentry.
    await Sentry.captureException(exception, stackTrace: stackTrace);
    rethrow;
  }
}

Future<List<ChartData>> getCompletedCoursesByDate() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }
    String userUID = user.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('CursosCompletados')
        .where('uid', isEqualTo: userUID)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    // Mapa para agrupar por fecha
    final Map<String, int> datosAgrupados = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      List<dynamic> fechas = data['timestamp'] ?? [];
      List<dynamic> cursos = data['IdCurso'] ?? [];

      // Asegurar que ambas listas tengan el mismo tamaño
      for (int i = 0; i < fechas.length; i++) {
        String fecha = fechas[i]; // Suponiendo que las fechas están en formato String "YYYY-MM-DD"

        // Contamos la cantidad de cursos por fecha
        datosAgrupados[fecha] = (datosAgrupados[fecha] ?? 0) + 1;
      }
    }

    print("Datos agrupados: $datosAgrupados");

    // Convertimos a lista de ChartData
    return datosAgrupados.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();
  } on FirebaseException catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    rethrow;
  } catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    rethrow;
  }
}
