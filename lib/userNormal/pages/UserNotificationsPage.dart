import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:testwithfirebase/userNormal/serviceuser/firebase_service.dart';

class UserNotificationsPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  UserNotificationsPage({super.key});

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
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2* 255).toInt()),
                blurRadius: 12,
                offset: const Offset(0, 6),
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

              // Contenido de notificaciones con ajuste dinámico
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firebaseService.getUserNotifications(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error al cargar notificaciones.'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No tienes notificaciones.'));
                    }

                    final notifications = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
                        final estado = notification['estado'] ?? 'Pendiente';
                        final mensajeAdmin = notification['mensajeAdmin'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Estado: $estado"),
                                if (mensajeAdmin.isNotEmpty)
                                  Text(
                                    "Mensaje: $mensajeAdmin",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                Text(timestamp != null ? timeago.format(timestamp) : 'Fecha no disponible'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, notification.id),
                            ),
                            onTap: () async {
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 **Confirmar eliminación de notificación**
  void _confirmDelete(BuildContext context, String notificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Notificación'),
          content: const Text('¿Está seguro de que desea eliminar esta notificación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService.deleteNotification(notificationId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificación eliminada correctamente.')),
                );
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
