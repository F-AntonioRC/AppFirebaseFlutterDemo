import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailMethods {
  // Obtener los empleados por campo
  Future<List<String>> getEmpleadosPorCampo(String campo, String valor) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Empleados')
          .where(campo, isEqualTo: valor)
          .get();

      // Extraer los correos directamente del campo 'correo'
      return querySnapshot.docs
          .map((doc) => doc['correo']?.toString())
          .where((correo) => correo != null)
          .cast<String>()
          .toList();
    } catch (e) {
      print('Error obteniendo correos: $e');
      return [];
    }
  }

  // Enviar correos
  Future<void> sendEmail(String campo,
      String valor,
      String nameCourse,
      String dateInit,
      String dateRegister,
      String dateSend,
      String body,) async {
    List<String> correos = await getEmpleadosPorCampo(campo, valor);

    if (correos.isEmpty) {
      await Sentry.captureMessage('¡Lista de correos vacia!');
      return;
    }

    String bodyFinal = ('$body\n'
        'Fecha de inicio: $dateInit\n'
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
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error enviando el correo: $e');
      }
    }
  }

// Función para validar esquemas en Chrome
  bool _isChromeTargetTopScheme(String url) {
    const Set<String> chromeTargetTopSchemes = <String>{
      'mailto',
      'https',
      'http',
    };
    final String? scheme = Uri
        .tryParse(url)
        ?.scheme;
    return chromeTargetTopSchemes.contains(scheme);
  }

  // Métodos específicos para Ore y sare
  Future<void> sendEmailToOre(String idOre,
      String nameCourse,
      String dateInit,
      String dateRegister,
      String dateSend,
      String body,) async {
    await sendEmail(
        'IdOre',
        idOre,
        nameCourse,
        dateInit,
        dateRegister,
        dateSend,
        body);
  }

  Future<void> sendEmailToSare(String idSare,
      String nameSare,
      String dateInit,
      String dateRegister,
      String dateSend,
      String body,) async {
    await sendEmail(
        'IdSare',
        idSare,
        nameSare,
        dateInit,
        dateRegister,
        dateSend,
        body);
  }

  // METODO PARA ENVIAR EMAIL A OUTLOOK
  Future<void> launchEmailWebWithOutlook(String email, String subject,
      String body) async {
    final Uri outlookUrl = Uri(
        scheme: 'https',
        host: 'outlook.live.com',
        path: '/owa/',
        query:
        'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(
            body)}');

    if (await canLaunchUrl(outlookUrl)) {
      await launchUrl(outlookUrl);
    } else {
      throw 'No se puede lanzar la URL para Outlook';
    }
  }

  List<List<String>> _splitList(List<String> list, int batchSize) {
    List<List<String>> batches = [];
    for (var i = 0; i < list.length; i += batchSize) {
      batches.add(
        list.sublist(
            i, i + batchSize > list.length ? list.length : i + batchSize),
      );
    }
    return batches;
  }

  void _validateUrlLength(Uri uri) {
    if (uri.toString().length > 2000) {
      throw 'La URL generada excede el límite permitido.';
    }
  }

  //METODO PARA ENVIAR EMAIL POR MAILTO
  Future<void> launchEmailWebFallback(String email, String subject,
      String body) async {
    const int maxEmailsPerBatch = 50; // Ajusta el tamaño según lo necesites
    List<String> emails = email.split(',');
    List<List<String>> emailBatches = _splitList(emails, maxEmailsPerBatch);

    for (var batch in emailBatches) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: batch.join(','),
        query:
        'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(
            body)}',
      );

      try {
        if (await canLaunchUrl(emailUri)) {
          _validateUrlLength(emailUri);
          await launchUrl(emailUri);
        } else {
          throw 'No se puede abrir el cliente de correo.';
        }
      } catch (e) {
        print('Error lanzando el correo: $e');
      }
    }
  }
}