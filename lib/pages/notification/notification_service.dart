import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Obtener notificaciones en tiempo real
  Stream<QuerySnapshot> getNotifications() {
    return _firestore.collection('notifications').orderBy('timestamp', descending: true).snapshots();
  }

  /// 🔹 Marcar un curso como completado y almacenarlo en "CursosCompletados"
  Future<void> marcarCursoCompletado(String userId, String cursoId, String evidenciaUrl) async {
    try {
      DocumentReference userDocRef = _firestore.collection('CursosCompletados').doc(userId);

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

  /// 🔹 Eliminar una notificación
  Future<void> eliminarNotificacion(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      print('Error al eliminar notificación: $e');
    }
  }

  /// 🔹 Marcar una notificación como leída
  Future<void> marcarNotificacionLeida(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
  }
}
