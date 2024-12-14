import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class CardWelcome extends StatelessWidget {
  const CardWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListTile(
                leading: const Icon(
                  Icons.insert_emoticon, color: greenColor, weight: 10.0, size: 50,),
                title: Text("Recuerda enviar tus constancias a tiempo",
                  style: TextStyle(fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),),
                subtitle: Text("Revisa tu correo también para verificar tus cursos",
                  style: TextStyle(fontSize: responsiveFontSize(context, 17),
                      fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
