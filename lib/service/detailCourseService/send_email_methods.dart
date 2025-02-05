import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// La clase `SendEmailMethods` contiene métodos para administrar el envio de correos desde la UI
/// y filtrarlos segun los parametros especificos.
class SendEmailMethods {

/// La función `sendEmail` realiza la estructura para enviar un correo electronico mediante
/// el metodo `launchEmailWebFallback`, enviando los datos para abrir la aplicación con los valores
/// correspondientes.
/// Parámetros:
/// - [nameCourse]: Valor del nombre del curso.
/// - [dateInit]: Valor de la fecha de inicio del curso asignado.
/// - [dateRegister]: Valor de la fecha de registro del curso asignado.
/// - [dateSend]: Valor de la fecha de envio de constancia del curso asignado.
/// - [body]: Cuerpo del correo
/// En caso de errores, se capturan y reportan a Sentry y se muestra un mensaje de error.
  Future<void> sendEmail(
    String nameCourse,
    String dateInit,
    String dateRegister,
    String dateSend,
    String body,
  ) async {
    // Construcción del cuerpo del correo.
    String bodyFinal = ('$body\n'
        'Fecha de inicio: $dateInit\n'
        'Fecha de registro: $dateRegister\n'
        'Envío de constancia: $dateSend');

    // Intentar abrir la aplicación de correo.
    try {
      if (_isChromeTargetTopScheme('mailto')) {
        await launchEmailWebFallback('Curso: $nameCourse', bodyFinal);
      } else {
        await launchEmailWebFallback('Curso: $nameCourse', bodyFinal);
      }
    } catch (e, stackTrace) {
      // Enviar y reportar el error a Sentry.
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

/// La función `_isChromeTargetTopScheme` Verifica si la URL tiene un esquema válido para
/// Chrome.
///
/// Los esquemas permitidos son: `mailto`, `https` y `http`.
  bool _isChromeTargetTopScheme(String url) {
    const Set<String> chromeTargetTopSchemes = <String>{ 'mailto', 'https', 'http' };
    final String? scheme = Uri.tryParse(url)?.scheme;
    return chromeTargetTopSchemes.contains(scheme);
  }

/// La función `copyEmailsToClipboard` copia una lista de correos electrónicos al
/// portapapeles del dispositivo.
///
/// Si la lista de correos está vacía, se captura un mensaje de error usando Sentry.
/// Si ocurre un error durante la copia, también se registra en Sentry.
///
/// Parametros:
/// - [emails]: Lista de correos electrónicos a copiar.
  Future<void> copyEmailsToClipboard(List<String> emails) async {
    if (emails.isNotEmpty) {
      // Separar los correos con una ', ' si existe emails.
      final emailList = emails.join(', ');
      try {
        // Intentar copiar la lista de correos.
        await Clipboard.setData(ClipboardData(text: emailList));
      } catch (e, stackTrace) {
        // Capturar los errores en Sentry.
        await Sentry.captureException(e, stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('Error_Copy_Emails_to_Clipboard', emailList);
        });
      }
    } else {
      await Sentry.captureMessage('copyEmailsToClipboard: No hay correos para copiar.');
    }
  }

/// La función `getAllCorreosByEmpleados` obtiene todos los correos electrónicos almacenados
/// en la colección 'Empleados' de Firebase.
///
/// Consulta la colección 'Empleados' en Firestore y extrae los valores del campo 'Correo'.
///
/// Retorna una lista de correos electrónicos obtenidos de la base de datos.
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

/// La función `getEmpleadosPorCampo` Obtiene una lista de correos electrónicos de empleados
  /// filtrados por un campo específico en Firestore.
///
/// Si el valor proporcionado está vacío, se captura un mensaje de error en Sentry.
/// De lo contrario, se consulta la colección 'Empleados' filtrando por el campo y el valor proporcionados.
///
/// Parametros:
/// - [campo]: Nombre del campo por el que se quiere filtrar.
/// - [valor]: Valor del campo que se desea buscar.
///
/// Retorna una lista de correos electrónicos que coincidan con el criterio de búsqueda.
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

/// La función `getFilteredEmails` filtra y obtiene correos electrónicos en función de un campo y
/// su valor, excluyendo valores vacíos o 'N/A'.
///
/// Si el valor proporcionado es vacío o 'N/A', se captura un mensaje de error en Sentry.
/// En caso contrario, llama a `getEmpleadosPorCampo` para obtener los correos filtrados.
///
/// Parametros:
/// - [campo]: Nombre del campo en Firestore por el cual filtrar.
/// - [valor]: Valor que debe coincidir en el campo especificado.
///
/// Retorna una lista de correos electrónicos que cumplen con el criterio.
  Future<List<String>> getFilteredEmails(String campo, String valor) async {
    if (valor.isEmpty || valor == 'N/A') {
      await Sentry.captureMessage('Error in getFilteredEmails: $valor');
      return [];
    }
    // Lista de correos obtenidos de la función `getEmpleadosPorCampo`.
    List<String> correos = await SendEmailMethods().getEmpleadosPorCampo(campo, valor);
    return correos;
  }

/// La función `launchEmailWebFallback` Intenta abrir un cliente de correo electrónico utilizando
/// el esquema `mailto`.
///
/// Si el esquema `mailto` no es soportado en el dispositivo, se captura un mensaje de error en Sentry.
/// En caso de error al abrir el enlace, la excepción se captura y registra en Sentry.
///
/// Parametros:
/// - [subject]: Asunto del correo electrónico.
/// - [body]: Cuerpo del correo electrónico.
  Future<void> launchEmailWebFallback(String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'correo@.com',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, webOnlyWindowName: '_blank');
      } else {
        Sentry.captureMessage('No se puede abrir el cliente de correo.');
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace,
          withScope: (scope) {
        scope.setTag('Url_launch_error', 'launchEmailWebFallback');
      });
    }
  }
}