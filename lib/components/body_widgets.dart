import 'package:flutter/material.dart';

class BodyWidgets extends StatelessWidget {
  final Widget body;

  const BodyWidgets({super.key, required this.body});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(15.0),
        child: body,
        ),
      ),
    );
  }
}
