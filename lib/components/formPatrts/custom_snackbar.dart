import 'package:flutter/material.dart';


/// La función `showCustomSnackBar` muestra una SnackBar con un estilo personalizado con un 
/// mensaje específico y estado de color en una aplicación Flutter.
/// 
/// Devuelve:
/// context (BuildContext): El parámetro `BuildContext` en Flutter representa la ubicación de un
/// widget dentro del árbol de widgets. Se utiliza para acceder a información sobre la ubicación del widget en
/// el árbol de widgets y para realizar varias operaciones como navegar a una nueva pantalla, mostrar diálogos,
/// y más. Es necesario para muchas operaciones en Flutter
/// message (String): El parámetro `message` en la función `showCustomSnackBar` es una cadena que
/// representa el contenido de texto que se mostrará en la SnackBar. Es el mensaje que desea
/// mostrar al usuario como una notificación o retroalimentación.
/// status (Color): El parámetro `status` en la función `showCustomSnackBar` se utiliza para especificar el
/// color de la Snackbar según el estado del mensaje que se muestra. Le permite personalizar
/// la apariencia de la Snackbar según diferentes estados o tipos de mensajes.
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
