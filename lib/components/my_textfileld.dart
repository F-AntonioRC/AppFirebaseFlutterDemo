import 'package:flutter/material.dart';

class MyTextfileld extends StatelessWidget {
  final String hindText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const MyTextfileld(
      {super.key,
      required this.hindText,
      required this.icon,
      required this.controller,
        required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return  TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
          hintText: hindText,
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0))
      ),
    );
  }
}
