import 'package:flutter/material.dart';

import '../util/responsive.dart';

class BuildField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final ThemeData theme;

  const BuildField({super.key,
    required this.title,
    required this.controller,
    required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: responsiveFontSize(context, 15),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        TextField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
