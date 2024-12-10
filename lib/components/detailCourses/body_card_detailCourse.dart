import 'package:flutter/material.dart';
import '../../util/responsive.dart';

class BodyCardDetailCourse extends StatelessWidget {
  final TextEditingController firstController;
  final String firstTitle;
  final Icon firstIcon;
  final TextEditingController secondController;
  final String secondTitle;
  final Icon secondIcon;

  const BodyCardDetailCourse({super.key,
    required this.firstController,
    required this.firstTitle,
    required this.secondController,
    required this.secondTitle,
    required this.firstIcon,
    required this.secondIcon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
          children: [
            Text(
              firstTitle,
              style: TextStyle(
                fontSize: responsiveFontSize(context, 15),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              readOnly: true,
              controller: firstController,
              decoration: InputDecoration(
                prefixIcon: firstIcon,
                disabledBorder: _buildDisabledBorder(theme),
                focusedBorder: _buildDisabledBorder(theme),
              ),
            ),
          ],
        ),),
        const SizedBox(width: 10.0),
        Expanded(child: Column(
          children: [
            Text(
              secondTitle,
              style: TextStyle(
                fontSize: responsiveFontSize(context, 15),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              readOnly: true,
              controller: secondController,
              decoration: InputDecoration(
                prefixIcon: secondIcon,
                disabledBorder: _buildDisabledBorder(theme),
                focusedBorder: _buildDisabledBorder(theme),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
InputBorder _buildDisabledBorder(ThemeData theme) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: theme.hintColor),
    borderRadius: BorderRadius.circular(10.0),
  );
}
