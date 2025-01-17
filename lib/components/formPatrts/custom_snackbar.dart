import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Color status) {
  final double screenWidth = MediaQuery.of(context).size.width;

  final snackBar = SnackBar(
    dismissDirection: DismissDirection.up,
    content: Text(
      message,
      style: const TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    duration: const Duration(milliseconds: 2000),
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height * 0.8,
      left: screenWidth * 0.3,
      right: screenWidth * 0.3
    ),
    backgroundColor: status,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
