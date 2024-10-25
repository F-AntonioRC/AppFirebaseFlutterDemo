import 'package:flutter/cupertino.dart';

class CircleColor extends StatelessWidget {
  final Color circleColor;

  const CircleColor({super.key, required this.circleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle
      ),
    );
  }
}
