import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/upFiles/data_from_table.dart';
import 'package:testwithfirebase/service/import_data_from_firebase.dart';
import 'package:testwithfirebase/components/upFiles/table_example.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

/// `MessageSendFile`
///
/// Widget que muestra un mensaje de verificación antes de importar datos desde un archivo Excel a Firebase.
///
/// Características:
/// - Muestra un mensaje de advertencia sobre la estructura del documento.
/// - Presenta una tabla de ejemplo (`TableExample`) con los datos esperados.
/// - Incluye botones de acción (`ActionsFormCheck`) para confirmar o cancelar la importación.
/// - Llama a la función `importExcelWithSareToFirebase()` para importar los datos.
/// - Muestra un `SnackBar` con el resultado de la operación.

class MessageSendFile extends StatefulWidget {
  // Constructor del widget `MessageSendFile`.
  const MessageSendFile({super.key});

  @override
  State<MessageSendFile> createState() => _MessageSendFileState();
}

class _MessageSendFileState extends State<MessageSendFile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mensaje de verificación sobre la estructura del documento.
          Text(
            'Verifique que la información del documento este estructurada de la siguiente manera:',
            style: TextStyle(
                fontSize: responsiveFontSize(context, 16),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox( height: 10.0 ),
          // Tabla de ejemplo que muestra la estructura esperada de los datos.
          TableExample(dataColumn: TableExampleData.columns, dataRow: TableExampleData.rows),
          const SizedBox( height: 10.0 ),
          // Botones de acción para confirmar o cancelar la importación.
          ActionsFormCheck(
            isEditing: true,
            // Validacion del documento con manejo de errores y envio a sentry.
            onUpdate: () async {
              try {
                await importExcelWithSareToFirebase();
                if(context.mounted) {
                  showCustomSnackBar(context, 'Datos agregados correctamente', greenColorLight);
                  Navigator.pop(context);
                }
              } catch (e, stackTrace) {
                if(context.mounted) {
                  showCustomSnackBar(context, 'Error $e', Colors.red);
                }
                await Sentry.captureException(e, stackTrace: stackTrace,
                withScope: (scope) {
                  scope.setTag('Error_Widget_MessageSendFile', 'Up File');
                }
                );
              }
            },
            onCancel: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
