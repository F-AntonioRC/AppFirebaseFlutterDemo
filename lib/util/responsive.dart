import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}

double responsiveFontSize(BuildContext context, double fontSize) {
  double width = MediaQuery.of(context).size.width;
  if (Responsive.isMobile(context)) {
    return fontSize * 0.8;
  } else if (Responsive.isTablet(context)) {
    return fontSize * 1.1;
  } else {
    return fontSize * 1.3;
  }
}