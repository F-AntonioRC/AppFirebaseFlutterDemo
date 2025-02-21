import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/auth/auth_service.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener cursos pendientes de un usuario
  Future<List<Map<String, dynamic>>> obtenerCursosPendientes(String userId, String cupo) async {
    /// This block of code is a method named `obtenerCursosPendientes` within the `FirebaseService`
    /// class. Here's a breakdown of what it does:
    try {
      // Obtener los IDs de los cursos completados
      final completadosSnapshot = await _firestore.collection('CursosCompletados').doc(userId).get();

      Set<String> cursosCompletados = {};
      if (completadosSnapshot.exists) {
        List<dynamic>? cursos = completadosSnapshot.data()?['IdCursosCompletados'];
        if (cursos != null) {
          cursosCompletados = cursos.cast<String>().toSet();
        }
      }

      // Obtener los cursos asignados basados en el CUPO del usuario
      final employeeSnapshot = await _firestore.collection('Empleados').where('CUPO', isEqualTo: cupo).get();

      if (employeeSnapshot.docs.isEmpty) {
        throw Exception('Empleado no encontrado');
      }

      final employeeData = employeeSnapshot.docs.first.data() as Map<String, dynamic>;
      final idOre = employeeData['IdOre'];
      final idSare = employeeData['IdSare'];

      if (idOre == null && idSare == null) {
        throw Exception('El empleado no tiene asignado un ORE ni un SARE.');
      }

      Query query = _firestore.collection('DetalleCursos');
      if (idOre != null) {
        query = query.where('IdOre', isEqualTo: idOre);
      }
      if (idSare != null) {
          query = query.where(Filter.or(
          Filter('IdSare', isEqualTo: idSare), 
          Filter('IdSare', isEqualTo: "10101"),
          Filter('IdSare', isEqualTo: "ORE"),
          ));
        
      }
      query = query.where('Estado', isEqualTo: 'Activo');
      final detalleCursosSnapshot = await query.get();

      // Filtrar los IDs de cursos no completados
      final cursosPendientesId = detalleCursosSnapshot.docs
          .map((doc) => doc['IdCurso'])
          .where((idCurso) => idCurso != null && !cursosCompletados.contains(idCurso))
          .toList();

      if (cursosPendientesId.isEmpty) {
        return [];
      }

      // Obtener los datos de los cursos pendientes desde la colección 'Cursos'
      final cursosSnapshot = await _firestore.collection('Cursos')
          .where(FieldPath.documentId, whereIn: cursosPendientesId)
          .get();

      return cursosSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error al obtener cursos pendientes: $e');
      return [];
    }
  }
   Future<void> deleteNotification(String notificationId) async {
   try {
    await _firestore.collection('notifications').doc(notificationId).update({
      'statusUser': 'inactivo' // Esta cambiado a inactivo
    });
    print('Notificación marcada como inactiva.');
  } catch (e) {
    print('Error al marcar notificación como inactiva: $e');
  }
  }

 Stream<QuerySnapshot> getUserNotifications(String userId) {
  return _firestore
      .collection('notifications')
      .where('uid', isEqualTo: userId)
      .where('statusUser', isEqualTo: 'activo') 
      .orderBy('timestamp', descending: true)
      .snapshots();
}
 Stream<QuerySnapshot> getUserNotificationsCount(String userId) {
  return _firestore
      .collection('notifications')
      .where('uid', isEqualTo: userId)
      .where('statusUser', isEqualTo: 'activo') 
      .orderBy('timestamp', descending: true)
      .snapshots();
}

}
