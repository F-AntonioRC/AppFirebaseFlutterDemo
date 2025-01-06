import 'package:flutter/material.dart';

class MyTextfileld extends StatelessWidget {
  final String hindText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const MyTextfileld(
      {super.key,
      required this.hindText,
      required this.icon,
      required this.controller,
      required this.keyboardType,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      //validator: validator,
      decoration: InputDecoration(
          hintText: hindText,
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
