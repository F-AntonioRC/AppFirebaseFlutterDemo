import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 🔹 Obtener notificaciones en tiempo real
  Stream<QuerySnapshot> getNotifications() {
  return _firestore
      .collection('notifications')
      .where('status', isEqualTo: 'activo') // 🔹 Solo traer notificaciones activas
      .orderBy('timestamp', descending: true)
      .snapshots()
      .handleError((error) {
        print(" Error en el stream de notificaciones: $error");
      });
}


  /// 🔹 Marcar un curso como completado y almacenarlo en "CursosCompletados"
  Future<void> marcarCursoCompletado(String userId, String cursoId, String evidenciaUrl) async {
    try {
      DocumentReference userDocRef = _firestore.collection('CursosCompletados').doc(userId);
      Timestamp timestamp = Timestamp.now();

      await userDocRef.set({
        'uid': userId,
        'IdCursosCompletados': FieldValue.arrayUnion([cursoId]),
        'FechaCursoCompletado': FieldValue.arrayUnion([timestamp]),
        'Evidencias': FieldValue.arrayUnion([evidenciaUrl]),
        'completado': true,
      }, SetOptions(merge: true));

      print('Curso marcado como completado.');
    } catch (e) {
      print('Error al marcar curso como completado: $e');
    }
  }

  ///metodo para rechazar una evidencia, 
  Future<void> rechazarEvidencia(String userId, String filePath, String notificationId) async {
     try {
      
      await _storage.ref(filePath).delete();
      print(' Archivo eliminado: $filePath');

      
      await _firestore.collection('notifications').doc(notificationId).update({
        'estado': 'Rechazado',
        'mensajeAdmin': 'Tu evidencia ha sido rechazada. Por favor, vuelve a subir un nuevo archivo.',
      });

      print(' Notificación actualizada como Rechazada.');
    } catch (e) {
      print(' Error al rechazar evidencia y eliminar archivo: $e');
    }
  }

  /// 🔹 Eliminar una notificación
  Future<void> eliminarNotificacion(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

Future<void> marcarNotificacionInactiva(String notificationId) async {
  try {
    await _firestore.collection('notifications').doc(notificationId).update({
      'status': 'inactivo' // Esta cambiado a inactivo
    });
    print('Notificación marcada como inactiva.');
  } catch (e) {
    print('Error al marcar notificación como inactiva: $e');
  }
}

  /// Metodo para marcar una notifacion como leida
  Future<void> marcarNotificacionLeida(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
  }
   Future<void> Aprobado(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({'mensajeAdmin': 'Aprobado'});
  }
}
