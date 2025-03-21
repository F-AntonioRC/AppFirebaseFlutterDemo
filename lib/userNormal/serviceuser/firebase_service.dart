import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener cursos pendientes de un usuario
  Future<List<Map<String, dynamic>>> obtenerCursosPendientes(String userId, String cupo) async {
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

    // ignore: unnecessary_cast
    final employeeData = employeeSnapshot.docs.first.data() as Map<String, dynamic>;
    final idOre = employeeData['IdOre'];
    final idSare = employeeData['IdSare'];

    if (idOre == null && idSare == null) {
      throw Exception('El empleado no tiene asignado un ORE ni un SARE.');
    }

    // Construcción de la consulta en DetalleCursos
   Query query = _firestore.collection('DetalleCursos');

// si el empleado tiene un IdOre, buscar cursos asignados por IdOre
if (idOre != null) {
  query = query.where(Filter.or(
    Filter('IdOre', isEqualTo: idOre), // Cursos asignados por ORE
    Filter('IdSare', isEqualTo: '10101'),
    Filter('IdSare', isEqualTo: '1')  // Cursos asignados a todos los ORE
  ));
}

//Si el empleado tiene un IdSare, buscar cursos específicos de su SARE
if (idSare != null) {
  query = query.where(Filter.or(
    Filter('IdSare', isEqualTo: idSare),  // Cursos asignados al SARE específico del usuario
    Filter('IdSare', isEqualTo: '10101') // Cursos generales asignados a todos
  ));
}
    query = query.where('Estado', isEqualTo: 'Activo');
    // Filtrar solo cursos activos
//DSFSDFSD

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

    // ignore: unnecessary_cast
    return cursosSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  } on FirebaseException catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('firebase_error_code', exception.code);
        
      },
    );
    
    return [];
  } on TypeError catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', 'type_error');
       
        
      },
    );
    
    return [];
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', 'unknown_exception');
        
      },
    );
   
    return [];
  }
}

  Future<void> deleteNotification(String notificationId) async {
  try {
    await _firestore.collection('notifications').doc(notificationId).update({
      'statusUser': 'inactivo' // Cambia el estado a inactivo
    });
    
  } on FirebaseException catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('firebase_error_code_no_se_marco_inactiva', exception.code);
        
      },
    );
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', 'unknown_exception');
        
      },
    );
  }
}


 Stream<QuerySnapshot> getUserNotifications(String userId) {
  try {
    return _firestore
        .collection('notifications')
        .where('uid', isEqualTo: userId)
        .where('statusUser', isEqualTo: 'activo') 
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error, stackTrace) async {
          await Sentry.captureException(
            error,
            stackTrace: stackTrace,
            withScope: (scope) {
              scope.setTag('function', 'getUserNotifications');
              
            },
          );
          
        });
  } catch (exception, stackTrace) {
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', 'unknown_exception');
        
      },
    );
    
    return const Stream.empty();
  }
}

Stream<QuerySnapshot> getUserNotificationsCount(String userId) {
  try {
    return _firestore
        .collection('notifications')
        .where('uid', isEqualTo: userId)
        .where('statusUser', isEqualTo: 'activo') 
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error, stackTrace) async {
          await Sentry.captureException(
            error,
            stackTrace: stackTrace,
            withScope: (scope) {
              scope.setTag('function', 'getUserNotificationsCount');
              
            },
          );
          
        });
  } catch (exception, stackTrace) {
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error_type', 'unknown_exception');
        
      },
    );
    
    return const Stream.empty();
  }
}


}
