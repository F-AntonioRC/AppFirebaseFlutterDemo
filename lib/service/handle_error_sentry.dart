import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';

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

