import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const MyButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: greenColor, foregroundColor: Colors.white),
            onPressed: onPressed,
            child: Text(text))
      ],
    );
  }
}
