import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';

class BodyuploadDocument extends StatefulWidget {
  final FirebaseDropdownController controllerCourse; // Controlador personalizado con la información del curso.

  const BodyuploadDocument(
      {super.key,
      required this.controllerCourse});

  @override
  State<BodyuploadDocument> createState() => _BodyuploadDocumentState();
}

class _BodyuploadDocumentState extends State<BodyuploadDocument> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
