import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/message_send_file.dart';
import 'package:testwithfirebase/util/responsive.dart';

class UpFileCard extends StatelessWidget {
  const UpFileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(
        body: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Subir datos de empleados',
            style: TextStyle(fontSize: responsiveFontSize(context, 20),
            fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 15.0),
          MyButton(
              text: 'Seleccionar archivos',
              icon: const Icon(Icons.upload_file_outlined),
              buttonColor: greenColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const BodyWidgets(body: MessageSendFile()),
                    ),
                  ),
                );
              },
          )
        ],
      ),
    ));
  }
}
