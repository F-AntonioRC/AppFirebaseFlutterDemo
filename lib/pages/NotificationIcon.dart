import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/AdminNotifcationsPage.dart';
//import 'AdminNotificationsPage.dart'; // Página de notificaciones

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: "Ver notificaciones",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNotificationsPage(),
              ),
            );
          },
        ),
        // Indicador de notificaciones no leídas (puedes enlazarlo con Firestore)
        Positioned(
          right: 8,
          top: 8,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Text(
              '3', // Cambia esto dinámicamente según las notificaciones no leídas
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
