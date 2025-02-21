import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/service/detailCourseService/send_email_methods.dart';
import '../../components/formPatrts/custom_snackbar.dart';

/// La función `sendEmail` genera un correo electrónico basado en los parámetros proporcionados.
///
/// Si el `idOre` está definido y no es 'N/A', se enviará el correo a la ORE correspondiente.
/// Si el `idSare` está definido y no es 'N/A', se enviará el correo al SARE correspondiente.
/// Si ninguno de los dos valores está disponible, se muestra un `SnackBar` indicando el error.
///
/// - [context]: Contexto de la aplicación para mostrar notificaciones.
/// - [bodyEmailController]: Controlador del campo de texto con el contenido del correo.
/// - [nameCourse]: Nombre del curso asociado al correo.
/// - [dateInit]: Fecha de inicio del curso.
/// - [dateRegister]: Fecha de registro del curso.
/// - [sendDocument]: Información sobre la fecha para el envio de constancia.
/// - [idOre]: (Opcional) Identificador del ORE.
/// - [idSare]: (Opcional) Identificador del SARE.
///
/// Captura excepciones con Sentry en caso de error.

Future<void> sendEmail(
    BuildContext context,
    TextEditingController bodyEmailController,
    String nameCourse,
    String dateInit,
    String dateRegister,
    String sendDocument,
    String? idOre,
    String? idSare) async {
  // Validaciones para el envio de correos dependiendo del Sare u Ore.
  if (idOre != null && idOre != 'N/A') {
    try {
      await SendEmailMethods().sendEmail(nameCourse, dateInit,
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
      await SendEmailMethods().sendEmail(nameCourse, dateInit,
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

/// La función `copyEmail` copia al portapapeles los correos electrónicos filtrados por
/// `idOre` o `idSare`.
///
/// Si `idOre` está definido y no es 'N/A', obtiene los correos de la ORE correspondiente.
/// Si `idSare` está definido y es '10101', obtiene todos los correos de la colección `Empleados`.
/// En otros casos, obtiene los correos filtrados por `idSare`.
///
/// Parametros:
/// - [context]: Contexto de la aplicación.
/// - [idOre]: (Opcional) Identificador de la ORE.
/// - [idSare]: (Opcional) Identificador del SARE.
///
/// Se eliminan correos duplicados antes de copiarlos al portapapeles.

Future<void> copyEmail(
    BuildContext context,
    String? idOre,
    String? idSare) async {
  List<String> correos = [];
  // Validaciones para el envio de correos dependiendo del Sare u Ore.
  if (idOre != null && idOre != 'N/A') {
    // Obtener correos filtrados por idOre
    List<String> correosIdOre = await SendEmailMethods().getFilteredEmails("IdOre", idOre);
    correos.addAll(correosIdOre);
  }
  if (idSare != null && idSare != 'N/A') {
    // Obtener correos Generales por idSare
    if(idSare == '10101') {
      List<String> totalCorreos = await SendEmailMethods().getAllCorreosByEmpleados();
      correos.addAll(totalCorreos);
    } else {
      // Obtener correos filtrados por idSare
      List<String> correosIdSare = await SendEmailMethods().getFilteredEmails("IdSare", idSare);
      correos.addAll(correosIdSare);
    }
  }
  // Eliminar correos duplicados
  correos = correos.toSet().toList();

  // Copiar correos al portapapeles si hay resultados
  if (correos.isNotEmpty) {
    await SendEmailMethods().copyEmailsToClipboard(correos);
  }
}
