import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';

class CardGraphics extends StatefulWidget {
  const CardGraphics({super.key, required this.cardWidget});

  final Widget cardWidget;

  @override
  State<CardGraphics> createState() => _CardGraphicsState();
}

class _CardGraphicsState extends State<CardGraphics> {
  @override
  Widget build(BuildContext context) {
    return BodyWidgets(
        body: SingleChildScrollView(
      child: widget.cardWidget,
    ));
  }
}
