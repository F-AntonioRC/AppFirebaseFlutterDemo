import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsDetailCourses {
  //REGISTRAR UN DETALLE CURSO
  Future addDetailCourse(
      Map<String, dynamic> detailCourseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .set(detailCourseInfoMap);
  }

  //ACTUALIZAR
  Future<void> updateDetalleCursos(
      String id, Map<String, dynamic> updateData) async {
    if (id.isEmpty || updateData.isEmpty) {
      throw Exception("El ID o los datos están vacíos.");
    }
    try {
      await FirebaseFirestore.instance
          .collection('DetalleCursos')
          .doc(id)
          .update(updateData);
    } catch (e) {
      throw Exception("Error al actualizar el empleado: $e");
    }
  }

  //ELIMINAR
  Future deleteDetalleCursos(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
      await documentReference.update({'Estado': 'Inactivo'});
    } catch (e) {
      print("Error: $e");
    }
  }

  //ACTIVAR
  Future ActivarDetalleCurso(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
      await documentReference.update({'Estado': 'Activo'});
    } catch (e) {
      print("Error: $e");
    }
  }


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
    } catch (e) {
      print('Error al obtener los datos: $e');
      throw e;
    }
  }

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
          'IdDetailCourse': detalleCursoDoc.id,
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
    } catch (e) {
      print('Error al realizar la consulta: $e');
      throw Exception('Error al realizar la consulta: $e');
    }
  }



}
