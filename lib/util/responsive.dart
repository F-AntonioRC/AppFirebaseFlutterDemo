import 'package:flutter/material.dart';

  /// Esta clase contiene métodos estáticos para determinar el tipo de dispositivo
  /// basado en el ancho de la pantalla.

class Responsive {
  /// Retorna `true` si el ancho de la pantalla es menor a 600 píxeles,
  /// lo que se considera un dispositivo móvil.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Retorna `true` si el ancho de la pantalla está entre 600 y 1099 píxeles,
  /// lo que se considera una tablet.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 600;

  /// Retorna `true` si el ancho de la pantalla es de 1100 píxeles o más,
  /// lo que se considera un dispositivo de escritorio (desktop).
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}

  /// Función que ajusta el tamaño de la fuente de forma responsiva
  /// en función del tamaño de la pantalla.
  ///
  /// [context]: El BuildContext actual para acceder a las propiedades de la pantalla.
  /// [fontSize]: El tamaño base de la fuente que se desea ajustar.
  ///
  /// Retorna el tamaño de fuente escalado de acuerdo a:
  /// - 70% del tamaño base en dispositivos móviles.
  /// - 110% del tamaño base en tablets.
  /// - 130% del tamaño base en escritorios.

double responsiveFontSize(BuildContext context, double fontSize) {
  if (Responsive.isMobile(context)) {
    return fontSize * 0.7;
  } else if (Responsive.isTablet(context)) {
    return fontSize * 1.1;
  } else {
    return fontSize * 1.3;
  }
}