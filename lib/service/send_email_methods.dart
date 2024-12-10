import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailMethods {

  //OBTENER LOS EMPLEADOS POR CAMPO
  Future<List<Map<String, dynamic>>> getEmpleadosPorCampo(String campo, String valor) async {

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .where(campo, isEqualTo: valor)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Función genérica para obtener correos según un campo (área o sare)
  Future<List<String>> getCorreoPorCampo(String campo, String valor) async {
    try {
      var empleados = await getEmpleadosPorCampo(campo, valor);
      List claves = empleados.map((e) => e['CUPO']?.toString()).where((cupo) => cupo != null).toList();

      if (claves.isEmpty) return []; // Evitar la consulta vacía

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('CUPO', whereIn: claves)
          .get();

      return querySnapshot.docs.map((doc) => doc['email'].toString()).toList();
    } catch (e) {
      print('Error obteniendo correos: $e');
      return [];
    }
  }

  // Función genérica para enviar correos
  Future<void> sendEmail(
      String campo, String valor, String nameCourse, String dateIniti,
      String dateRegister, String dateSend, String body) async {
    List<String> correos = await getCorreoPorCampo(campo, valor);

    if (correos.isEmpty) {
      print('No se encontraron correos para $campo: $valor');
      return;
    }

    String bodyFinal = '$body\n'
        'Fecha de inicio: $dateIniti\n'
        'Fecha de registro: $dateRegister\n'
        'Envío de constancia: $dateSend';

    final String emailList = correos.join(',');
    final Uri gmailUrl = Uri(
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
    );

    try {
      if (await canLaunchUrl(gmailUrl)) {
        await launchUrl(gmailUrl, mode: LaunchMode.externalApplication);
      } else {
        print('No se pudo lanzar Gmail');
      }
    } catch (e) {
      print('Error al intentar lanzar Gmail: $e');
    }
  }

  // Métodos específicos para área y sare
  Future<void> sendEmailToArea(
      String idArea, String nameCourse, String dateIniti,
      String dateRegister, String dateSend, String body) async {
    await sendEmail('IdArea', idArea, nameCourse, dateIniti, dateRegister, dateSend, body);
  }

  Future<void> sendEmailToSare(
      String idSare, String nameSare, String dateIniti,
      String dateRegister, String dateSend, String body) async {
    await sendEmail('IdSare', idSare, nameSare, dateIniti, dateRegister, dateSend, body);
  }

}