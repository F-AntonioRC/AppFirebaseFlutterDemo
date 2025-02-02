import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/graphics/model_chart.dart';

/// La función consulta una colección específica en Firestore y agrupa los documentos
/// en función del valor del campo [campo]. Para cada valor, se cuenta la cantidad de ocurrencias,
/// generando una lista de objetos [ChartData] que contienen la etiqueta y su respectivo conteo.
///
/// Si un documento no contiene el campo especificado, se asigna el valor por defecto 'S/A'.
///
/// En caso de error, se capturan y reportan las excepciones a Sentry, relanzándolas para ser
/// manejadas aguas arriba.
///
/// [collection]: Nombre de la colección en Firestore donde se encuentran los datos.
/// [campo]: Nombre del campo en los documentos que se utilizará para agrupar la información.
///
/// Retorna un [Future] que resuelve una lista de [ChartData] con los datos agrupados.

Future<List<ChartData>> getDataEmployeeForGraphic(String collection, String campo) async {
  try {
    // Se obtiene un snapshot de la colección en Firestore.
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    // Mapa para agrupar los datos: la clave es el valor del campo y el valor es el contador.
    final Map<String, int> datosAgrupados = {};

    // Recorre cada documento del snapshot.
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String value = data[campo] ?? 'S/A'; // Si no hay área, asignamos 'Sin Área'

      // Incrementar el contador de empleados
      if (datosAgrupados.containsKey(value)) {
        datosAgrupados[value] =
            datosAgrupados[value]! + 1;
      } else {
        // Primera ocurrencia del valor.
        datosAgrupados[value] = 1;
      }
    }

    // Se convierte el mapa agrupado en una lista de ChartData.
    return datosAgrupados.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
  } on FirebaseException catch (exception, stackTrace) {
    // Captura excepciones específicas de Firebase y las reporta a Sentry.
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('firebase_error_graphic', exception.code);
      },
    );
    rethrow; // Relanzar la excepción
  } catch (exception, stackTrace) {
    // Captura y reporta cualquier otra excepción a Sentry.
    await Sentry.captureException(exception, stackTrace: stackTrace);
    rethrow;
  }
}