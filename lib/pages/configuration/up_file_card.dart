import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
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
              onPressed: () {},
          )
        ],
      ),
    ));
  }
}
