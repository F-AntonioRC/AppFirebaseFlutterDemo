import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MethodsDetailCourses {

  //REGISTRAR UN DETALLE CURSO
  Future addDetailCourse(Map<String, dynamic> detailCourseInfoMap,
      String id) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .set(detailCourseInfoMap);
  }

  //ELIMINAR
  Future deleteDetalleCursos(String id) async {
    try{
      DocumentReference documentReference = FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
      await documentReference.update({'Estado' : 'Inactivo'});
    } catch(e) {
      print("Error: $e");
    }
  }

  //BUSCAR LOS EMPLEADOS POR ARE
  Future<List<Map<String, dynamic>>> getEmpleadosPorArea(String area) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('IdArea', isEqualTo: area)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER LOS CORREOS POR AREA
  Future<List<String>> getCorreoPorArea(String area) async {
    var empleados = await getEmpleadosPorArea(area);

    List claves = empleados.map((e) => e['CUPO'].toString()).toList();

    if(claves.isEmpty) return []; //Evitar la consulta vacia

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection('User')
    .where('CUPO', whereIn: claves)
    .get();

    return querySnapshot.docs.map((doc) => doc['email'].toString()).toList();
  }

  Future<void> sendEmailToArea(String idArea) async {
    List<String> correos = await getCorreoPorArea(idArea);

    if(correos.isNotEmpty) {
      final String emailList = correos.join(',');

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: emailList,
        query: _encodeQueryParameters(<String, String> {
          'subject' : 'Asunto del correo',
          'body': 'Cuerpo del mensaje'
        })
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        print('No se pudo lanzar el cliente de correo');
      }
    } else {
      print('No se encontraron correos para el área $idArea');
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  //ACTIVAR
  Future ActivarDetalleCurso(String id) async {
    try{
      DocumentReference documentReference = FirebaseFirestore.instance.collection('DetalleCursos').doc(id);
      await documentReference.update({'Estado' : 'Activo'});
    } catch(e) {
      print("Error: $e");
    }
  }

  //BUSCAR UN DETALLE DEL CURSO
  Future<List<Map<String, dynamic>>> searchDeatilCoursesByName(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .where('NameCourse', isGreaterThanOrEqualTo: name)
        .where('NameCourse', isLessThan: '${name}z') // Para búsquedas "que empiezan con minuscula"
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
        String? idArea = detalleCursoDoc['IdArea'];
        String? idSare = detalleCursoDoc['IdSare'];

        Map<String, dynamic> result = {};

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
          DocumentSnapshot areaDoc =
          await firestore.collection('Area').doc(idArea).get();

          if (areaDoc.exists) {
            var areaData = areaDoc.data() as Map<String, dynamic>;
            result['NombreArea'] = areaData['NombreArea'];
          }


        // Consulta el documento de Sare si existe idSare
          DocumentSnapshot sareDoc =
          await firestore.collection('Sare').doc(idSare).get();

          if (sareDoc.exists) {
            var sareData = sareDoc.data() as Map<String, dynamic>;
            result['sare'] = sareData['sare'];
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
        String? idArea = detalleCursoDoc['IdArea'];
        String? idSare = detalleCursoDoc['sare'];

        Map<String, dynamic> result = {};

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
        if (idArea != null) {
          DocumentSnapshot areaDoc =
          await firestore.collection('Area').doc(idArea).get();

          if (areaDoc.exists) {
            var areaData = areaDoc.data() as Map<String, dynamic>;
            result['NombreArea'] = areaData['Nombre'];
          }
        }

        // Consulta el documento de Sare si existe idSare
        if (idSare != null) {
          DocumentSnapshot sareDoc =
          await firestore.collection('Sare').doc(idSare).get();

          if (sareDoc.exists) {
            var sareData = sareDoc.data() as Map<String, dynamic>;
            result['NombreSare'] = sareData['Nombre'];
          }
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