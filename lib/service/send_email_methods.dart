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
        final batch =
            claves.sublist(i, i + 10 > claves.length ? claves.length : i + 10);

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('CUPO', whereIn: batch)
            .get();

        correos
            .addAll(querySnapshot.docs.map((doc) => doc['email'].toString()));
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

    String bodyFinal = ('$body\n'
        'Fecha de inicio: $dateIniti\n'
        'Fecha de registro: $dateRegister\n'
        'Envío de constancia: $dateSend');

    final String emailList = correos.join(',');

    try {
      if (_isChromeTargetTopScheme('mailto')) {
        await launchEmailWebFallback(
            emailList, 'Curso: $nameCourse', bodyFinal);
      } else {
        await launchEmailWebFallback(
            emailList, 'Curso: $nameCourse', bodyFinal);
        await launchEmailWebWithOutlook(emailList, 'Curso: $nameCourse', bodyFinal);
      }
    } catch (e) {
      print('Error enviando el correo: $e');
    }
  }

// Función para validar esquemas en Chrome
  bool _isChromeTargetTopScheme(String url) {
    const Set<String> chromeTargetTopSchemes = <String>{
      'mailto',
      'https',
      'http',
    };
    final String? scheme = Uri.tryParse(url)?.scheme;
    return chromeTargetTopSchemes.contains(scheme);
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
    await sendEmail(
        'IdArea', idArea, nameCourse, dateIniti, dateRegister, dateSend, body);
  }

  Future<void> sendEmailToSare(
    String idSare,
    String nameSare,
    String dateIniti,
    String dateRegister,
    String dateSend,
    String body,
  ) async {
    await sendEmail(
        'IdSare', idSare, nameSare, dateIniti, dateRegister, dateSend, body);
  }


  // MÉTODO PARA ENVIAR EMAIL A OUTLOOK
  Future<void> launchEmailWebWithOutlook(
      String email, String subject, String body) async {
    final Uri outlookUrl = Uri(
      scheme: 'https',
      host: 'outlook.live.com',
      path: '/owa/',
      queryParameters: {
        'path': '/mail/action/compose',
        'to': email,
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(outlookUrl)) {
      await launchUrl(outlookUrl);
    } else {
      throw 'No se puede lanzar la URL para Outlook';
    }
  }


  //MÉTODO PARA ENVIAR EMAIL POR MAILTO
  Future<void> launchEmailWebFallback(
      String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'No se puede abrir el cliente de correo.';
      }
    } catch (e) {
      print('Error lanzando el correo: $e');
    }
  }
}
