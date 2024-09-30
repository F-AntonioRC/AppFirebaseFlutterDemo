import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/card_preview.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final FirebaseDropdownController _controllerCourse =
      FirebaseDropdownController();
  final FirebaseDropdownController _controllerDependency =
      FirebaseDropdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Email'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Course',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            FirebaseDropdown(
              controller: _controllerCourse,
              collection: "Courses",
              data: "NameCourse",
              textHint: 'Select a Course',
            ),
            const SizedBox(height: 10.0),
            const Text('Dependency',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            FirebaseDropdown(
                controller: _controllerDependency,
                collection: 'Dependency',
                data: 'Name',
                textHint: 'Select a Dependency'),
            const SizedBox(height: 10.0),
            const Text('Preview',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            CardPreview(
              nameCourse: 'Telegram',
              nameDependency: 'Bienestar',
            )
          ],
        ),
      ),
    );
  }
}
