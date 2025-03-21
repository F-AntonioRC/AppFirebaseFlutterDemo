import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/courses/courses.dart';
import 'package:testwithfirebase/util/responsive.dart';

class GetApk extends StatefulWidget {
  const GetApk({super.key});

  @override
  State<GetApk> createState() => _GetApkState();
}

class _GetApkState extends State<GetApk> {
  get builder => null;

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Descargar APP', style: TextStyle(
          fontSize: responsiveFontSize(context, 18),
          fontWeight: FontWeight.bold
        ),),
        const SizedBox(height: 5.0),
        MyButton(text: 'Descargar', icon: Icon(Icons.download), 
        buttonColor: Colors.brown, onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return Courses();
          });
        },)
      ],
    ));
  }
}