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

  //BUSCAR UN DETALLE DEL CURSO
  Future<List<Map<String, dynamic>>> searchDeatilCoursesByName(
      String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .where('NameCourse', isGreaterThanOrEqualTo: name)
        .where('NameCourse',
            isLessThan:
                '${name}z') // Para búsquedas "que empiezan con minuscula"
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getDatosDetalleCursosActivos() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Paso 1: Consulta todos los documentos activos en DetalleCursos
      QuerySnapshot detalleCursosQuery = await firestore
          .collection('DetalleCursos')
          .where('Estado', isEqualTo: 'Activo')
          .get();

      if (detalleCursosQuery.docs.isEmpty) {
        return [];
      }

      // Paso 2: Itera sobre los documentos obtenidos y consulta datos relacionados
      List<Map<String, dynamic>> results = [];

      for (var detalleCursoDoc in detalleCursosQuery.docs) {
        String idCourse = detalleCursoDoc['IdCourse'];
        String? idOre = detalleCursoDoc['IdOre'];
        String? idSare = detalleCursoDoc['IdSare'];

        // Inicializa todos los campos con valores predeterminados
        Map<String, dynamic> result = {
          'IdDetailCourse': detalleCursoDoc.id, // Asignar un ID único si aplica
          'NameCourse': 'N/A',
          'FechaInicioCurso': 'N/A',
          'Fecharegistro': 'N/A',
          'FechaenvioConstancia': 'N/A',
          'Ore': 'N/A',
          'IdOre': null,
          'sare': 'N/A',
          'IdSare': null,
          'IdCourse': null,
          'Estado': detalleCursoDoc['Estado'] ?? 'N/A'
        };

        // Consulta el documento de Courses
        DocumentSnapshot courseDoc =
            await firestore.collection('Courses').doc(idCourse).get();

        if (courseDoc.exists) {
          var courseData = courseDoc.data() as Map<String, dynamic>;
          result['IdCourse'] = courseData['IdCourse'];
          result['NameCourse'] = courseData['NameCourse'];
          result['FechaInicioCurso'] = courseData['FechaInicioCurso'];
          result['Fecharegistro'] = courseData['Fecharegistro'];
          result['FechaenvioConstancia'] = courseData['FechaenvioConstancia'];
        }

        // Consulta el documento de Area si existe idArea
        DocumentSnapshot OreDoc =
            await firestore.collection('Ore').doc(idOre).get();

        if (OreDoc.exists) {
          var areaData = OreDoc.data() as Map<String, dynamic>;
          result['Ore'] = areaData['Ore'] ?? 'N/A';
          result['IdOre'] = areaData['IdOre'];
        }

        // Consulta el documento de Sare si existe idSare
        DocumentSnapshot sareDoc =
            await firestore.collection('Sare').doc(idSare).get();

        if (sareDoc.exists) {
          var sareData = sareDoc.data() as Map<String, dynamic>;
          result['sare'] = sareData['sare'] ?? 'N/A';
          result['IdSare'] = sareData['IdSare'];
        }

        results.add(result);
      }

      return results;
    } catch (e) {
      print('Error al obtener los datos: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getDatosDetalleCursosInac() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Paso 1: Consulta todos los documentos activos en DetalleCursos
      QuerySnapshot detalleCursosQuery = await firestore
          .collection('DetalleCursos')
          .where('Estado', isEqualTo: 'Inactivo')
          .get();

      if (detalleCursosQuery.docs.isEmpty) {
        return [];
      }

      // Paso 2: Itera sobre los documentos obtenidos y consulta datos relacionados
      List<Map<String, dynamic>> results = [];

      for (var detalleCursoDoc in detalleCursosQuery.docs) {
        String idCourse = detalleCursoDoc['IdCourse'];
        String? idOre = detalleCursoDoc['IdOre'];
        String? idSare = detalleCursoDoc['IdSare'];

        // Inicializa todos los campos con valores predeterminados
        Map<String, dynamic> result = {
          'IdDetailCourse': detalleCursoDoc.id, // Asignar un ID único si aplica
          'NameCourse': 'N/A',
          'FechaInicioCurso': 'N/A',
          'Fecharegistro': 'N/A',
          'FechaenvioConstancia': 'N/A',
          'Ore': 'N/A',
          'IdOre': 'N/A',
          'sare': 'N/A',
          'IdSare': 'N/A',
          'Estado': detalleCursoDoc['Estado'] ?? 'N/A'
        };

        // Consulta el documento de Courses
        DocumentSnapshot courseDoc =
            await firestore.collection('Courses').doc(idCourse).get();

        if (courseDoc.exists) {
          var courseData = courseDoc.data() as Map<String, dynamic>;
          result['NameCourse'] = courseData['NameCourse'];
          result['FechaInicioCurso'] = courseData['FechaInicioCurso'];
          result['Fecharegistro'] = courseData['Fecharegistro'];
          result['FechaenvioConstancia'] = courseData['FechaenvioConstancia'];
        }

        // Consulta el documento de Area si existe idArea
        DocumentSnapshot OreDoc =
            await firestore.collection('Ore').doc(idOre).get();

        if (OreDoc.exists) {
          var areaData = OreDoc.data() as Map<String, dynamic>;
          result['Ore'] = areaData['Ore'] ?? 'N/A';
          result['IdOre'] = areaData['IdOre'];
        }

        // Consulta el documento de Sare si existe idSare
        DocumentSnapshot sareDoc =
            await firestore.collection('Sare').doc(idSare).get();

        if (sareDoc.exists) {
          var sareData = sareDoc.data() as Map<String, dynamic>;
          result['sare'] = sareData['sare'] ?? 'N/A';
          result['IdSare'] = sareData['IdSare'];
        }

        results.add(result);
      }

      return results;
    } catch (e) {
      print('Error al obtener los datos: $e');
      throw e;
    }
  }

}
