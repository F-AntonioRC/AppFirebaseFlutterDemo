import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';


/// Esta función maneja los errores capturándolos en Sentry y mostrando un mensaje 
/// personalizado en la interfaz de usuario.
/// 
/// Argumentos:
/// contexto (BuildContext): El parámetro `context` en la función `handleError` es del tipo
/// `BuildContext` y se utiliza para proporcionar información sobre la ubicación del widget dentro del
/// árbol de widgets.
/// excepción (dinamic): el parámetro `excepción` en la función `handleError` se utiliza para pasar el
/// error o excepción que ocurrió en su aplicación. Puede ser cualquier tipo de objeto de error o
/// excepción que desee manejar e informar.
/// stackTrace (StackTrace): El parámetro `stackTrace` en la función `handleError` se usa para
/// proporcionar información sobre la secuencia de llamadas de función que llevaron al error. Ayuda a
/// depurar y comprender el flujo del programa en el momento en que ocurrió el error. 
/// operation (String): El parámetro `operación` en la función `handleError` es un parámetro obligatorio
/// que representa la operación o acción que se estaba realizando cuando ocurrió el error.
/// Se utiliza para etiquetar el error en Sentry para una mejor categorización y seguimiento.
/// customMessage (String): El parámetro `customMessage` en la función `handleError` es una cadena
/// que le permite proporcionar un mensaje de error personalizado para que se muestre en la IU. 
/// Si no se proporciona un mensaje personalizado, se establecerá de forma predeterminada "Error: ", 
/// donde '$exception' es la cadena que representa el error.
/// contextData (Map<String, dynamic>): El parámetro `contextData` en la función `handleError` es un
/// mapa que le permite proporcionar datos contextuales adicionales relacionados con el error que se 
/// está manejando. Estos datos se pueden usar para proporcionar más información sobre el error al 
/// capturarlo en Sentry, puede incluir cualquier par clave-valor.
Future<void> handleError({
  required BuildContext context,
  required dynamic exception,
  required StackTrace stackTrace,
  required String operation,
  String? customMessage,
  Map<String, dynamic>? contextData,
}) async {
  // Captura el error en Sentry
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
    withScope: (scope) {
      scope.setTag('operation', operation);
      if (contextData != null) {
        scope.setContexts('operation_context', contextData);
      }
    },
  );

  // Muestra un mensaje en la UI
  if (context.mounted) {
    showCustomSnackBar(
      context,
      customMessage ?? "Error: $exception",
      Colors.red,
    );
  }
}