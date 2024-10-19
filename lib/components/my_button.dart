import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon icon;

  const MyButton(
      {super.key, required this.text, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: greenColor,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          ),
          onPressed: onPressed,
          icon: icon,
          iconAlignment: IconAlignment.end,
          label: Text(
            text,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
