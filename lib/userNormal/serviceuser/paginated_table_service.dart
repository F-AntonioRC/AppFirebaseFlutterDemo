import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PaginatedTableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchCompletedCourses() async {

    try {

      final _auth = FirebaseAuth.instance;

      String uid = _auth.currentUser?.uid ?? '';

      QuerySnapshot cursosCompletadosSnapshot =
      await _firestore.collection('CursosCompletados').where('uid', isEqualTo: uid).get();

      Map<dynamic, String> idCursoFechaMap = {}; // Mapeo de IdCurso -> FechaCursoCompletado

      for (var doc in cursosCompletadosSnapshot.docs) {
        List<dynamic> ids = doc['IdCursosCompletados'] ?? [];
        List<dynamic> fechas = doc['FechaCursoCompletado'] ?? [];

        // Asegurar que cada ID tenga una fecha correspondiente
        for (int i = 0; i < ids.length; i++) {
          Timestamp? timestamp = (i < fechas.length) ? fechas[i] as Timestamp? : null;
          String formattedDate = timestamp != null
              ? DateFormat('dd/MM/yyyy/ - HH:mm:ss').format(timestamp.toDate()) // Formato legible
              : "Fecha no disponible";

          idCursoFechaMap[ids[i]] = formattedDate;
        }
      }

      if (idCursoFechaMap.isEmpty) return [];

      List<Map<String, dynamic>> tempRows = [];

      // Dividir en grupos de 10 para whereIn
      List<List<dynamic>> batches = [];
      List<dynamic> idCursosCompletados = idCursoFechaMap.keys.toList();

      for (var i = 0; i < idCursosCompletados.length; i += 10) {
        batches.add(idCursosCompletados.sublist(
            i, i + 10 > idCursosCompletados.length ? idCursosCompletados.length : i + 10));
      }

      // Consultar 'Cursos' en lotes
      for (var batch in batches) {
        QuerySnapshot cursosSnapshot = await _firestore
            .collection('Cursos')
            .where('IdCurso', whereIn: batch)
            .get();

        tempRows.addAll(cursosSnapshot.docs.map((doc) {
          dynamic idCurso = doc["IdCurso"];
          return {
            "Nombre del curso": doc["NombreCurso"] ?? "N/A",
            "Fecha de envio de Constancia": idCursoFechaMap[idCurso] ?? "Fecha no disponible",
          };
        }).toList());
      }

      return tempRows;
    } catch (e) {
      print("Error al obtener datos: $e");
      return [];
    }
  }


}
