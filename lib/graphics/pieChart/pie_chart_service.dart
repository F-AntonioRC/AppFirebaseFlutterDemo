
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/graphics/model_chart.dart';

Future<List<ChartData>> getDataEmployeeForGraphic(String collection, String campo) async {
  try {
    final snapshot =
    await FirebaseFirestore.instance.collection(collection).get();
    final Map<String, int> datosAgrupados = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String value = data[campo] ??
          'S/A'; // Si no hay área, asignamos 'Sin Área'

      // Incrementar el contador de empleados
      if (datosAgrupados.containsKey(value)) {
        datosAgrupados[value] =
            datosAgrupados[value]! + 1;
      } else {
        datosAgrupados[value] =
        1; // Primera vez que se encuentra el área
      }
    }

    // Convertimos el mapa a una lista de ChartData
    return datosAgrupados.entries
        .map((entry) => ChartData(entry.key, entry.value))
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