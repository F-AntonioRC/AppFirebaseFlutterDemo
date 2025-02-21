import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testwithfirebase/components/formPatrts/ink_component.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
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
    
  }

  /// Verifica si el usuario es administrador
  

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
 Future<void> marcarCursoCompletado(String userId, String cursoId, String evidenciaUrl) async {
  try {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('CursosCompletados').doc(userId);

    // Obtener timestamp manualmente
    Timestamp timestamp = Timestamp.now();

    await userDocRef.set({
      'uid': userId,
      'IdCursosCompletados': FieldValue.arrayUnion([cursoId]), // 🔹 Agregar curso al array
      'FechaCursoCompletado': FieldValue.arrayUnion([timestamp]), // 🔹 Agregar fecha manualmente
      'Evidencias': FieldValue.arrayUnion([evidenciaUrl]), // 🔹 Agregar URL de la evidencia
      'completado': true, // 🔹 Mantener este campo como referencia
    }, SetOptions(merge: true)); // 🔹 Evita sobrescribir datos anteriores

    print('Curso marcado como completado.');
  } catch (e) {
    print('Error al marcar curso como completado: $e');
  }
}




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
                        child: Text('No hay notificacione NOWs'),
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
    child: Icon(
      isRead ? Icons.check : Icons.new_releases,
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
        notification['uploader'] ?? 'Usuario desconocido',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      Text(
        timestamp != null
            ? timeago.format(timestamp)
            : 'Fecha no disponible',
      ),
    ],
  ),
  trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () async {
                final userId = notification['uid']; // ID del usuario
                final cursoId = notification['IdCurso']; // ID del curso
                final evidenciaUrl = notification['pdfUrl']; // URL de la evidencia
                if (userId != null && cursoId != null && evidenciaUrl != null) {
                  await marcarCursoCompletado(userId, cursoId, evidenciaUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Curso marcado como completado.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Faltan datos para marcar el curso como completado.'),
                    ),
                  );
                }
              },
            ),
            InkComponent(tooltip: 'Eliminar', 
                iconInk: const Icon(Icons.delete, color: wineLight,), 
                inkFunction: () {
                  FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(notification.id)
                      .delete();
                }),
          ],
        ),
      
  onTap: () async {
    final pdfUrl = notification['pdfUrl'];
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notification.id)
        .update({'isRead': true});
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