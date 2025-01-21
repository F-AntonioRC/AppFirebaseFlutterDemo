import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../model_chart.dart';

class LineChartService {

  Future<List<ChartData>> getDataBySelect(String collection,
      String dataChange) async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection(collection).get();
      final Map<String, int> datosAgrupados = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String selectData =
            data[dataChange] ?? 'N/A'; // Si no hay área, asignamos 'Sin Área'

        // Incrementar el contador de empleados en lugar de sumar CUPO
        if (datosAgrupados.containsKey(selectData)) {
          datosAgrupados[selectData] = datosAgrupados[selectData]! + 1;
        } else {
          datosAgrupados[selectData] =
          1; // Primera vez que se encuentra el área
        }
      }

      // Convertimos el mapa a una lista de ChartData
      return datosAgrupados.entries.map((entry) {
        return ChartData(entry.key, entry.value);
      }).toList();
    } on FirebaseException catch (exception, stackTrace) {
      // Maneja excepciones específicas de Firebase
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('firebase_error_graphic', exception.code);
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

