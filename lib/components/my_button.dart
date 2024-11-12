import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon icon;
  final Color buttonColor;

  const MyButton(
      {super.key, required this.text, this.onPressed, required this.icon, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          ),
          onPressed: onPressed,
          icon: icon,
          iconAlignment: IconAlignment.end,
          label: Text(
            text,
            style: TextStyle(fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
