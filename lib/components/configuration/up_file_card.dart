import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/configuration/message_send_file.dart';
import 'package:testwithfirebase/util/responsive.dart';

  /// La clase `UpFileCard` es un StatelessWidget que muestra en la UI la opcion de subir un archivo
  /// para cargar registros a la base de datos mediante un Widget Dialog.

class UpFileCard extends StatelessWidget {
  const UpFileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(
        body: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  // Titulo de la acción
                  Text(
                    'Subir datos de empleados',
                    style: TextStyle(fontSize: responsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Boton para seleccionar el archivo desde donde se cargaran los datos
                  MyButton(
                    text: 'Seleccionar archivos',
                    icon: const Icon(Icons.upload_file_outlined),
                    buttonColor: greenColor,
                    onPressed: () {
                      // Muestra un Dialog con un alto predeterminado y un ancho responsivo
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
              )
            ],
          ),
        ],
      ),
    ));
  }
}
