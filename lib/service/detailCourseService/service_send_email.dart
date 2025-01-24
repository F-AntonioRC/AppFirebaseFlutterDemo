import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/service/detailCourseService/send_email_methods.dart';
import '../../components/formPatrts/custom_snackbar.dart';

Future<void> sendEmail(
    BuildContext context,
    TextEditingController bodyEmailController,
    String nameCourse,
    String dateInit,
    String dateRegister,
    String sendDocument,
    String? nameArea,
    String? nameSare,
    String? idOre,
    String? idSare) async {
  if (idOre != null && idOre != 'N/A') {
    try {
      await SendEmailMethods().sendEmailToOre(nameCourse, dateInit,
          dateRegister, sendDocument, bodyEmailController.text.trim());
    } catch (e, stackTrace) {
      await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        withScope: (scope) {
            scope.setTag('Send_email_to_Ore', idOre);
        }
      );
    }
  } else if (idSare != null && idSare != 'N/A') {
    try {
      await SendEmailMethods().sendEmailToSare(nameCourse, dateInit,
          dateRegister, sendDocument, bodyEmailController.text.trim());
    } catch (e, stackTrace) {
      await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          withScope: (scope) {
            scope.setTag('Send_email_to_Sare', idSare);
          }
      );
    }
  } else {
    if (context.mounted) {
      showCustomSnackBar(
          context, 'No se encontro Area o sare asignado', Colors.red);
    }
  }
}

Future<void> copyEmail(
    BuildContext context,
    String? idOre,
    String? idSare) async {
  List<String> correos = [];

  if (idOre != null && idOre != 'N/A') {
    // Obtener correos filtrados por idOre
    List<String> correosIdOre = await SendEmailMethods().getFilteredEmails("IdOre", idOre);
    correos.addAll(correosIdOre);
  }

  if (idSare != null && idSare != 'N/A') {
    // Obtener correos filtrados por idSare
    List<String> correosIdSare = await SendEmailMethods().getFilteredEmails("IdSare", idSare);
    correos.addAll(correosIdSare);
  }

  // Eliminar correos duplicados (opcional)
  correos = correos.toSet().toList();

  // Copiar correos al portapapeles si hay resultados
  if (correos.isNotEmpty) {
    await SendEmailMethods().copyEmailsToClipboard(correos);
  }
}
