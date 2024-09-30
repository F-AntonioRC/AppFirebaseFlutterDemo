import 'package:flutter/material.dart';

class MyTextfileld extends StatelessWidget {
  final String hindText;
  final Icon icon;
  final TextEditingController controller;
  final bool obsecureText;
  final TextInputType keyboardType;

  const MyTextfileld(
      {super.key,
      required this.hindText,
      required this.icon,
      required this.controller,
      required this.obsecureText,
        required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return  TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
          hintText: hindText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
          ),
          prefixIcon: icon,
          prefixIconColor: Colors.grey.shade900,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade900), borderRadius: BorderRadius.circular(12.0))),
    );
  }
}
