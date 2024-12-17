import 'package:flutter/material.dart';

class CardGraphics extends StatefulWidget {
  const CardGraphics({super.key, required this.cardWidget});

  final Widget cardWidget;

  @override
  State<CardGraphics> createState() => _CardGraphicsState();
}

class _CardGraphicsState extends State<CardGraphics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),  // Bordes redondeados
        ),
        child: Padding(padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: widget.cardWidget,
        ),),
      ),
    );
  }
}
