import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';

class CardViewCourse extends StatelessWidget {
  final String assetImagePath;
  final String title;
  final String subtitle;

  const CardViewCourse({super.key,
    required this.assetImagePath,
    required this.title,
    required this.subtitle});

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              assetImagePath,
              width: screenWidth * 0.9,
              height: screenHeight * 0.25,
              fit: BoxFit.cover,
            ),
          ),
          const Divider(),
          const SizedBox(height: 10.0,),
          Text(title, style: TextStyle(
              fontSize: responsiveFontSize(context, 18),
              fontWeight: FontWeight.bold
          ),),
          Text(subtitle, style: TextStyle(
              fontSize: responsiveFontSize(context, 16),
              fontWeight: FontWeight.bold
          ),),
        ],
      ),)
    );
  }
}
