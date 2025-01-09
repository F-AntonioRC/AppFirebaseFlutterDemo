import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

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
            showDialog(
              context: context,
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
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
                        final isRead = notification['isRead'] ?? false;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isRead ? Colors.grey : Colors.blueAccent,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification['uploader']??'usuario desconocido',
                                style:const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                timestamp != null
                                    ? timeago.format(timestamp)
                                    : 'Fecha no disponible',
                              ),
                            ],
                          ),
                          trailing: isAdmin
                              ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('notifications')
                                  .doc(notification.id)
                                  .delete();
                            },
                          )
                              : null,
                          onTap: () async {
                            final pdfUrl = notification['pdfUrl'];
                            FirebaseFirestore.instance
                                .collection('notifications')
                                .doc(notification.id)
                                .update({'isRead': true});
                            if(pdfUrl !=null && pdfUrl.isNotEmpty){
                              try{
                                if(await canLaunch(pdfUrl)){
                                  await launch(pdfUrl);
                                } else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('no se puede abrir el archivo pdf')),
                                  );
                                }

                              }
                              catch(e){
                                print('error al abrir el archivo PDF: $e');
                              }
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('no se puede abrir el archivo pdf')),
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
