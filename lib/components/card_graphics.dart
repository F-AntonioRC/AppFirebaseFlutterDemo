import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

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
      margin: const EdgeInsets.all(10.0),
      child: Card(
        color: darkBackground,
        elevation: 5.0,  // Agregue elevación para un mejor efecto visual
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),  // Bordes redondeados
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: widget.cardWidget,
        ),
      ),
    );
  }
}
