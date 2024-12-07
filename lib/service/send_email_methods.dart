import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailMethods {

  //OBTENER LOS EMPLEADOS POR AREA
  Future<List<Map<String, dynamic>>> getEmpleadosPorArea(String area) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('IdArea', isEqualTo: area)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER LOS EMPLEADOS POR SARE
  Future<List<Map<String, dynamic>>> getEmpleadosPorSare(String sare) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('IdSare', isEqualTo: sare)
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

  //OBTENER LOS CORREOS POR SARE
  Future<void> sendEmailToArea(
      String idArea, String nameCourse, String dateIniti,
      String dateRegister, String dateSend, String body) async {
    List<String> correos = await getCorreoPorArea(idArea);

    String bodyFinal = '$body \n Fecha de inicio: $dateIniti,  Fecha de registro: $dateRegister, Envio de constancia: $dateSend ';

    if (correos.isNotEmpty) {
      final String emailList = correos.join(',');

      final String gmailUrl = Uri(
        scheme: 'https',
        host: 'mail.google.com',
        path: '/mail/',
        queryParameters: {
          'view': 'cm',
          'fs': '1',
          'to': emailList,
          'su': 'Curso: $nameCourse',
          'body': bodyFinal,
        },
      ).toString();

      if (await canLaunchUrl(Uri.parse(gmailUrl))) {
        await launchUrl(Uri.parse(gmailUrl), mode: LaunchMode.externalApplication);
      } else {
        print('No se pudo lanzar Gmail');
      }
    } else {
      print('No se encontraron correos para el área $idArea');
    }
  }

  Future<void> sendEmailToSare(
      String idSare, String nameSare, String dateIniti,
      String dateRegister, String dateSend, String body) async {
    List<String> correos = await getCorreoPorArea(idSare);

    String bodyFinal = '$body \n Fecha de inicio: $dateIniti,  Fecha de registro: $dateRegister, Envio de constancia: $dateSend ';

    if (correos.isNotEmpty) {
      final String emailList = correos.join(',');

      final String gmailUrl = Uri(
        scheme: 'https',
        host: 'mail.google.com',
        path: '/mail/',
        queryParameters: {
          'view': 'cm',
          'fs': '1',
          'to': emailList,
          'su': 'Curso: $nameSare',
          'body': bodyFinal,
        },
      ).toString();

      if (await canLaunchUrl(Uri.parse(gmailUrl))) {
        await launchUrl(Uri.parse(gmailUrl), mode: LaunchMode.externalApplication);
      } else {
        print('No se pudo lanzar Gmail');
      }
    } else {
      print('No se encontraron correos para el área $idSare');
    }
  }

}