import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({super.key});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  final User? user = FirebaseAuth.instance.currentUser; // Usuario actual
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  /// Verifica si el usuario es administrador
  Future<void> _checkIfAdmin() async {
    if (user == null) return;

    final adminDoc = await FirebaseFirestore.instance
        .collection('admins') // Asegúrate de tener una colección 'admins'
        .doc(user!.uid)
        .get();

    setState(() {
      isAdmin = adminDoc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (context) => NotificationDrawer(isAdmin: isAdmin),
            );
          },
        ),
        Positioned(
          right: 0,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('isRead', isEqualTo: false) // No leídas
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${snapshot.data!.docs.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationDrawer extends StatelessWidget {
  final bool isAdmin;

  const NotificationDrawer({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final notifications = snapshot.data!.docs;
                  if (notifications.isEmpty) {
                    return const Center(
                      child: Text('No hay notificaciones'),
                    );
                  }

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
                      final isRead = notification['isRead'] ?? false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            isRead ? Icons.check : Icons.new_releases,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          notification['fileName'] ?? 'Notificación',
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                    'Curso: ${notification['course']}\n'
                    'Subido por: ${notification['uploader']}\n'
                    'Fecha: ${notification['timestamp']?.toDate() ?? 'Desconocida'}',
                  ),
                        /*
                        subtitle: Text(
                          timestamp != null
                              ? timeago.format(timestamp)
                              : 'Fecha no disponible',
                        ),*/
                        trailing: isAdmin
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Eliminar') {
                                    FirebaseFirestore.instance
                                        .collection('notifications')
                                        .doc(notification.id)
                                        .delete();
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'Eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              )
                            : null,
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(notification.id)
                              .update({'isRead': true});
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
    );
  }
}
    