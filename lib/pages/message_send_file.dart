import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/upFiles/table_example.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MessageSendFile extends StatelessWidget {
  const MessageSendFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Por favor verifique que la información del documento este estructurada de la siguiente manera:',
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
        ActionsFormCheck(isEditing: true, onUpdate: () {}, onCancel: () {})
      ],
    );
  }
}
