import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
    duration: const Duration(milliseconds: 2000),
    width: 350,
    backgroundColor: Colors.grey[800],
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)
    ),
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
