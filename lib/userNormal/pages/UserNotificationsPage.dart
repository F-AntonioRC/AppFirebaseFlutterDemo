import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('No autenticado.'));
    }

    return Align(
      alignment: Alignment.topRight,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.only(top: 60, right: 10),
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Notificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
             Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('notifications')
        .where('uid', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        print("🔄 Cargando notificaciones...");
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        print(" Error en Stream: ${snapshot.error}");
        return const Center(child: Text('Error al cargar notificaciones.'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        print(" No hay notificaciones en Firestore.");
        return const Center(child: Text('No tienes notificaciones.'));
      }

      final notifications = snapshot.data!.docs;
      print(" Notificaciones cargadas correctamente: ${notifications.length}");
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
          final estado = notification['estado'] ?? 'Pendiente';
          final mensajeAdmin = notification['mensajeAdmin'] ?? '';
          final bool isRead = notification['isRead'] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  estado == 'Aprobado'
                      ? Icons.check_circle
                      : estado == 'Rechazado'
                          ? Icons.cancel
                          : Icons.info,
                  color: estado == 'Aprobado'
                      ? Colors.green
                      : estado == 'Rechazado'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
              title: Text(
                notification['fileName'] ?? 'Notificación',
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estado: $estado",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (mensajeAdmin.isNotEmpty)
                    Text(
                      "Mensaje del Administrador: $mensajeAdmin",
                      style: const TextStyle(color: Colors.red),
                    ),
                  Text(timestamp != null ? timeago.format(timestamp) : 'Fecha no disponible'),
                ],
              ),
              /*
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.blue),
                onPressed: () async {
                  final pdfUrl = notification['pdfUrl'];
                  if (pdfUrl != null && pdfUrl.isNotEmpty) {
                    if (await canLaunch(pdfUrl)) {
                      await launch(pdfUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se puede abrir el archivo PDF')),
                      );
                    }
                  }
                },
              ),*/
            ),
          );
        },
      );
    },
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
