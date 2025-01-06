
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/graphics/model_chart.dart';

Future<List<ChartData>> getDataEmployeeByDependency() async {
  final snapshot =
  await FirebaseFirestore.instance.collection('Employee').get();
  final Map<String, int> agrupadosPorDependencia = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final String dependencia = data['Dependencia'] ?? 'S/A'; // Si no hay área, asignamos 'Sin Área'

    // Incrementar el contador de empleados
    if (agrupadosPorDependencia.containsKey(dependencia)) {
      agrupadosPorDependencia[dependencia] = agrupadosPorDependencia[dependencia]! + 1;
    } else {
      agrupadosPorDependencia[dependencia] = 1; // Primera vez que se encuentra el área
    }
  }

  // Convertimos el mapa a una lista de ChartData
  return agrupadosPorDependencia.entries
      .map((entry) => ChartData(entry.key, entry.value))
      .toList();
}

Future<List<ChartData>> getDataBySare() async {
  final snapshot =
  await FirebaseFirestore.instance.collection('Employee').get();
  final Map<String, int> agrupadosPorSare = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final String sare = data['Sare'] ?? 'S/S'; // Si no hay sare, asignamos 'Sin sare'

    // Incrementar el contador de empleados
    if (agrupadosPorSare.containsKey(sare)) {
      agrupadosPorSare[sare] = agrupadosPorSare[sare]! + 1;
    } else {
      agrupadosPorSare[sare] = 1; // Primera vez que se encuentra el área
    }
  }

  // Convertimos el mapa a una lista de ChartData
  return agrupadosPorSare.entries
      .map((entry) => ChartData(entry.key, entry.value))
      .toList();
}

Future<List<ChartData>> getDataByTrimestre() async {
  final snapshot =
  await FirebaseFirestore.instance.collection('Courses').get();
  final Map<String, int> agrupadosPorTrimestre = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final String trimestre = data['Trimestre'] ?? 'S/S'; // Si no hay sare, asignamos 'Sin sare'

    // Incrementar el contador de empleados
    if (agrupadosPorTrimestre.containsKey(trimestre)) {
      agrupadosPorTrimestre[trimestre] = agrupadosPorTrimestre[trimestre]! + 1;
    } else {
      agrupadosPorTrimestre[trimestre] = 1; // Primera vez que se encuentra el área
    }
  }

  // Convertimos el mapa a una lista de ChartData
  return agrupadosPorTrimestre.entries
      .map((entry) => ChartData(entry.key, entry.value))
      .toList();
}