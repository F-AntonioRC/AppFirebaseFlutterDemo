import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/upFiles/import_data_from_firebase.dart';
import 'package:testwithfirebase/components/upFiles/table_example.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MessageSendFile extends StatelessWidget {
  const MessageSendFile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Verifique que la información del documento este estructurada de la siguiente manera:',
            style: TextStyle(
                fontSize: responsiveFontSize(context, 16),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const TableExample(),
          const SizedBox(
            height: 10.0,
          ),
          ActionsFormCheck(
            isEditing: true,
            onUpdate: () async {
              try {
                await importExcelWithSareToFirebase();
                if(context.mounted) {
                  showCustomSnackBar(context, 'Datos agregados correctamente', greenColor);
                  Navigator.pop(context);
                }
              } catch (e) {
                if(context.mounted) {
                  showCustomSnackBar(context, 'Error $e', Colors.red);
                }
              }
            },
            onCancel: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
