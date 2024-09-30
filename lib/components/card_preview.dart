import 'package:flutter/material.dart';

class CardPreview extends StatefulWidget {
  final String nameCourse;
  final String nameDependency;

  // Constructor para recibir los datos
  const CardPreview({
    super.key,
    required this.nameCourse, // Recibe el valor de nameCourse
    required this.nameDependency, // Recibe el valor de nameDependency
  });

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.outgoing_mail, color: Colors.green),
              // Muestra los datos recibidos
              title: Text(widget.nameCourse ?? 'Course not provided'),
              subtitle: Text(widget.nameDependency ?? 'Dependency not provided'),
            ),
          ],
        ),
      ),
    );
  }
}
