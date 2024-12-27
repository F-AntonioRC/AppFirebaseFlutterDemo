import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/card_view_data_courses.dart';

class SendDocument extends StatefulWidget {
  const SendDocument({super.key});

  @override
  State<SendDocument> createState() => _SendDocumentState();
}

class _SendDocumentState extends State<SendDocument> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const Padding(padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: CardViewDataCourses(
                        assetImagePath: 'assets/images/logo.jpg',
                        title: "Cursos asignados:",
                        subtitle: "Primer Trimestre")),
                SizedBox(width: 10.0),
                Expanded(
                    child: CardViewDataCourses(
                        assetImagePath: 'assets/images/logo.jpg',
                        title: "Cursos asignados:",
                        subtitle: "Segundo Trimestre")),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                    child: CardViewDataCourses(
                        assetImagePath: 'assets/images/logo.jpg',
                        title: "Cursos asignados:",
                        subtitle: "Tercer Trimestre")),
                SizedBox(width: 10.0),
                Expanded(
                    child: CardViewDataCourses(
                        assetImagePath: 'assets/images/logo.jpg',
                        title: "Cursos asignados:",
                        subtitle: "Cuarto Trimestre")),
              ],
            ),
          ],
        ),
      ),),

    );
  }
}
