import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailMethods {
  // Obtener los empleados por campo
  Future<List<Map<String, dynamic>>> getEmpleadosPorCampo(
      String campo, String valor) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .where(campo, isEqualTo: valor)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error obteniendo empleados: $e');
      return [];
    }
  }

  // Obtener correos según un campo
  Future<List<String>> getCorreoPorCampo(String campo, String valor) async {
    try {
      var empleados = await getEmpleadosPorCampo(campo, valor);
      List<String?> claves = empleados
          .map((e) => e['CUPO']?.toString())
          .where((cupo) => cupo != null)
          .cast<String>()
          .toList();

      if (claves.isEmpty) return [];

      // Dividir en lotes si es necesario
      final List<String> correos = [];
      for (var i = 0; i < claves.length; i += 10) {
        final batch = claves.sublist(i, i + 10 > claves.length ? claves.length : i + 10);

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('CUPO', whereIn: batch)
            .get();

        correos.addAll(querySnapshot.docs.map((doc) => doc['email'].toString()));
      }

      return correos;
    } catch (e) {
      print('Error obteniendo correos: $e');
      return [];
    }
  }

  // Enviar correos
  Future<void> sendEmail(
      String campo,
      String valor,
      String nameCourse,
      String dateIniti,
      String dateRegister,
      String dateSend,
      String body,
      ) async {
    List<String> correos = await getCorreoPorCampo(campo, valor);

    if (correos.isEmpty) {
      print('No se encontraron correos para $campo: $valor');
      return;
    }

    String bodyFinal = Uri.encodeComponent('$body\n'
        'Fecha de inicio: $dateIniti\n'
        'Fecha de registro: $dateRegister\n'
        'Envío de constancia: $dateSend');

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
      String idArea,
      String nameCourse,
      String dateIniti,
      String dateRegister,
      String dateSend,
      String body,
      ) async {
    await sendEmail('IdArea', idArea, nameCourse, dateIniti, dateRegister, dateSend, body);
  }

  Future<void> sendEmailToSare(
      String idSare,
      String nameSare,
      String dateIniti,
      String dateRegister,
      String dateSend,
      String body,
      ) async {
    await sendEmail('IdSare', idSare, nameSare, dateIniti, dateRegister, dateSend, body);
  }
}
