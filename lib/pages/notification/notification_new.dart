import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
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
          constraints: const BoxConstraints(maxWidth: 500), 
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2*255).toInt()),
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
                child: SingleChildScrollView(
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
                          final isRead = notification['isRead'] ?? false;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            leading: CircleAvatar(
                              child: Icon(isRead ? Icons.check : Icons.new_releases),
                            ),
                            title: Text(
                              notification['fileName'] ?? 'Notificación',
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['uploader'] ?? 'Usuario desconocido',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(timestamp != null ? timeago.format(timestamp) : 'Fecha no disponible'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: light,
                                  child: IconButton(
                                      onPressed: () => _confirmarCompletado(
                                    context,
                                    notification['uid'],
                                    notification['IdCurso'],
                                    notification['pdfUrl'],
                                    notification.id,
                                  ),
                                      icon: const Icon(Icons.check_circle_outline, color: greenColorLight,),
                                      tooltip: 'Aceptar',
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                CircleAvatar(
                                  backgroundColor: light,
                                  child: IconButton(
                                    onPressed: () => _rechazarEvidencia(
                                      context,
                                      notification['uid'],
                                      notification.id,
                                      notification['filePaht'],
                                    ),
                                    icon: const Icon(Icons.cancel_outlined, color: wineLight,),
                                    tooltip: 'Rechazar',
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final pdfUrl = notification['pdfUrl'];
                              _notificationService.marcarNotificacionLeida(notification.id);
                              if (pdfUrl != null && pdfUrl.isNotEmpty) {
                                // ignore: deprecated_member_use
                                if (await canLaunch(pdfUrl)) {
                                  // ignore: deprecated_member_use
                                  await launch(pdfUrl);
                                } else {
                                  if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se puede abrir el archivo PDF')),
                                  );
                                  } 
                                  
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarCompletado(BuildContext context, String userId, String cursoId, String evidenciaUrl, String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Está seguro de marcar este curso como completado?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionsFormCheck(
                isEditing: true,
                onCancel: () => Navigator.of(context).pop(),
                onUpdate: () async {
                  Navigator.of(context).pop();
                  await _notificationService.marcarCursoCompletado(userId, cursoId, evidenciaUrl);
                  await _notificationService.marcarNotificacionInactiva(notificationId);
                  await _notificationService.aprobado(notificationId);
                  if(context.mounted) {
                    showCustomSnackBar(context,
                        'Curso marcado como completado y notificación eliminada.',
                        greenColorLight);
                  }
                },
              )
            ],
          ),
      
        ],
      ),
    );
  }

  void _rechazarEvidencia(BuildContext context, String userId, String notificationId, String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rechazar Evidencia"),
        content: const Text("¿Está seguro de rechazar la evidencia? Se eliminará el archivo y el usuario deberá subir uno nuevo."),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionsFormCheck(
                isEditing: true,
                onCancel: () => Navigator.of(context).pop(),
                onUpdate: () async {
                Navigator.of(context).pop();
              await _notificationService.rechazarEvidencia(userId, filePath, notificationId);
              await _notificationService.marcarNotificacionInactiva(notificationId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Evidencia rechazada, archivo eliminado y usuario notificado.")),
                );
              }
                },
              )
            ],
          ),

        ],
      ),
    );
  }
}
