import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailMethods {
  // Enviar correos
  Future<void> sendEmail(
    String nameCourse,
    String dateInit,
    String dateRegister,
    String dateSend,
    String body,
  ) async {

    String bodyFinal = ('$body\n'
        'Fecha de inicio: $dateInit\n'
        'Fecha de registro: $dateRegister\n'
        'Envío de constancia: $dateSend');

    try {
      if (_isChromeTargetTopScheme('mailto')) {
        await launchEmailWebFallback('Curso: $nameCourse', bodyFinal);
      } else {
        await launchEmailWebFallback('Curso: $nameCourse', bodyFinal);
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('Url_launcher_error', 'sendEmail');
          scope.setContexts('Data: ', nameCourse);
        }
      );
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

  Future<void> copyEmailsToClipboard(List<String> emails) async {
    if (emails.isNotEmpty) {
      final emailList = emails.join(', ');
      try {
        await Clipboard.setData(ClipboardData(text: emailList));
      } catch (e, stackTrace) {
        await Sentry.captureException(e, stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('Error_Copy_Emails_to_Clipboard', emailList);
        });
      }
    } else {
      await Sentry.captureMessage('copyEmailsToClipboard: No hay correos para copiar.');
    }
  }

  // Métodos específicos para Ore y sare
  Future<void> sendEmailToOre(
    String nameCourse,
    String dateInit,
    String dateRegister,
    String dateSend,
    String body,
  ) async {

    await sendEmail(
        nameCourse, dateInit, dateRegister, dateSend, body);
  }

  Future<void> sendEmailToSare(
    String nameCourse,
    String dateInit,
    String dateRegister,
    String dateSend,
    String body,
  ) async {

    await sendEmail(
        nameCourse, dateInit, dateRegister, dateSend, body);
  }

  // Obtener los empleados por campo
  Future<List<String>> getAllCorreosByEmpleados() async {

    // Ejecutar la consulta a Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Empleados')
        .get();

    // Extraer y retornar los correos
    final correos = querySnapshot.docs
        .map((doc) => doc['Correo']?.toString())
        .where((correo) => correo != null)
        .cast<String>()
        .toList();

    return correos;
  }

  // Obtener los empleados por campo
  Future<List<String>> getEmpleadosPorCampo(String campo, String valor) async {
    if (valor.isEmpty) {
      await Sentry.captureMessage(
          'Error: El valor para el campo "$campo" está vacío.');
      return [];
    }

    // Ejecutar la consulta a Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Empleados')
        .where(campo, isEqualTo: valor)
        .get();

    // Extraer y retornar los correos
    final correos = querySnapshot.docs
        .map((doc) => doc['Correo']?.toString())
        .where((correo) => correo != null)
        .cast<String>()
        .toList();

    return correos;
  }

  Future<List<String>> getFilteredEmails(String campo, String valor) async {
    if (valor.isEmpty || valor == 'N/A') {
      await Sentry.captureMessage('Error in getFilteredEmails: $valor');
      return [];
    }

    List<String> correos = await SendEmailMethods().getEmpleadosPorCampo(campo, valor);
    return correos;
  }

  //METODO PARA ENVIAR EMAIL POR MAILTO
  Future<void> launchEmailWebFallback(String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'correo@.com',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'No se puede abrir el cliente de correo.';
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace,
          withScope: (scope) {
        scope.setTag('Url_launch_error', 'launchEmailWebFallback');
      });
    }
  }
}
