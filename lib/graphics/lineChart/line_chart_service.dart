import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../model_chart.dart';

  /// La clase `LineChartService` es el servicio encargado de obtener y procesar los datos para
/// la generación de gráficos.
  ///
  /// La clase `LineChartService` se conecta a Firestore para obtener datos de una colección
  /// específica y agruparlos, devolviendo una lista de objetos [ChartData] que pueden ser
  /// utilizados para renderizar gráficos.

class LineChartService {

  /// La función `getDataBySelect` btiene y agrupa datos de una colección de Firestore.
  ///
  /// [collection]: Nombre de la colección en Firestore desde donde se obtendrán los datos.
  ///
  /// [dataChange]: Nombre del campo en cada documento que se utilizará para agrupar la información.
  ///
  /// Retorna una [Future] que resuelve una lista de [ChartData] con los datos agrupados.
  ///
  /// Durante el proceso, se cuenta la cantidad de ocurrencias para cada valor encontrado en
  /// el campo [dataChange]. Si algún documento no posee el campo, se asigna el valor `'N/A'`.
  ///
  /// En caso de errores relacionados con Firebase, se captura la excepción utilizando Sentry,
  /// se etiqueta con el código de error y se relanza la excepción. Se sigue un proceso similar
  /// para cualquier otra excepción.

  Future<List<ChartData>> getDataBySelect(String collection,
      String dataChange) async {
    try {
      // Se obtiene un snapshot de la colección especificada en Firestore.
      final snapshot =
      await FirebaseFirestore.instance.collection(collection).get();
      // Mapa para agrupar los datos, contando las ocurrencias de cada valor.
      final Map<String, int> datosAgrupados = {};

      // Recorre cada documento del snapshot.
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Se obtiene el valor del campo especificado; si no existe, se asigna 'N/A'.
        final String selectData =
            data[dataChange] ?? 'N/A';

        // Incrementa el contador para el valor encontrado.
        if (datosAgrupados.containsKey(selectData)) {
          datosAgrupados[selectData] = datosAgrupados[selectData]! + 1;
        } else {
          // Primera ocurrencia del valor.
          datosAgrupados[selectData] = 1;
        }
      }

      // Se convierte el mapa agrupado en una lista de ChartData.
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

  /// La función `getArrayDataByDate` Obtiene y agrupa datos de una colección de Firebase Firestore
  /// según un campo de tipo lista que contiene fechas en formato Timestamp.
  ///
  /// Agrupa los datos por mes en formato "YYYY-MM" y devuelve una lista de `ChartData`.
  ///
  /// [collection] Nombre de la colección en Firestore.
  /// [dateField] Nombre del campo que contiene la lista de fechas (como Timestamp).
  ///
  /// Retorna una lista de objetos `ChartData` con la cantidad de elementos por mes.
  Future<List<ChartData>> getArrayDataByDate(String collection, String dateField) async {
    try {
      // Se obtienen los documentos de la colección
      final snapshot = await FirebaseFirestore.instance.collection(collection).get();
      final Map<String, int> datosAgrupados = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // Validación si el campo es una lista
        if (data[dateField] is List) {
          List<dynamic> arrayValues = data[dateField];

          for (var value in arrayValues) {
            if (value is Timestamp) {
              DateTime date = value.toDate(); // Convierte Timestamp a DateTime

              // Formatea la fecha como "YYYY-MM" para agrupar por mes
              String key = "${date.year}-${date.month.toString().padLeft(2, '0')}";

              if (datosAgrupados.containsKey(key)) {
                datosAgrupados[key] = datosAgrupados[key]! + 1;
              } else {
                datosAgrupados[key] = 1;
              }
            }
          }
        }
      }
      // Convertir el mapa en una lista de ChartData
      return datosAgrupados.entries.map((entry) {
        return ChartData(entry.key, entry.value);
      }).toList();
    } on FirebaseException catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace, withScope: (scope) {
        scope.setTag('firebase_error_graphic_array', exception.code);
      });
      rethrow;
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }
}