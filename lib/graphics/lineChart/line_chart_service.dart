import 'package:cloud_firestore/cloud_firestore.dart';
import '../model_chart.dart';

class LineChartService {
  Future<List<ChartData>> getDataBySelect(String collection,
      String dataChange) async {
    final snapshot =
    await FirebaseFirestore.instance.collection('Courses').get();
    final Map<String, int> datosAgrupados = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String selectData =
          data[dataChange] ?? 'N/A'; // Si no hay área, asignamos 'Sin Área'

      // Incrementar el contador de empleados en lugar de sumar CUPO
      if (datosAgrupados.containsKey(selectData)) {
        datosAgrupados[selectData] = datosAgrupados[selectData]! + 1;
      } else {
        datosAgrupados[selectData] = 1; // Primera vez que se encuentra el área
      }
    }

    // Convertimos el mapa a una lista de ChartData
    return datosAgrupados.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();
  }
}