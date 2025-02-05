 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/pages/notification/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
class NotificationNew extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

   NotificationNew({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Notificaciones',
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
                  stream: _notificationService.getNotifications(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notifications = snapshot.data!.docs;
                    if (notifications.isEmpty) {
                      return const Center(child: Text('No hay notificaciones'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
                        final isRead = notification['isRead'] ?? false;

                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(isRead ? Icons.check : Icons.new_releases),
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
                                notification['uploader'] ?? 'Usuario desconocido',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(timestamp != null ? timeago.format(timestamp) : 'Fecha no disponible'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () async {
                                  final userId = notification['uid'];
                                  final cursoId = notification['IdCurso'];
                                  final evidenciaUrl = notification['pdfUrl'];
                                  if (userId != null && cursoId != null && evidenciaUrl != null) {
                                    await _notificationService.marcarCursoCompletado(userId, cursoId, evidenciaUrl);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Curso marcado como completado.')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Faltan datos para marcar el curso como completado.')),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _notificationService.eliminarNotificacion(notification.id);
                                },
                              ),
                            ],
                          ),
                          onTap: () async {
                            final pdfUrl = notification['pdfUrl'];
                            _notificationService.marcarNotificacionLeida(notification.id);
                            if (pdfUrl != null && pdfUrl.isNotEmpty) {
                              try {
                                if (await canLaunch(pdfUrl)) {
                                  await launch(pdfUrl);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se puede abrir el archivo PDF')),
                                  );
                                }
                              } catch (e) {
                                print('Error al abrir el archivo PDF: $e');
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No se puede abrir el archivo PDF')),
                              );
                            }
                          },
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
}