// user_profile_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para crear o actualizar el perfil de usuario en Firestore
  Future<void> createUserProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Referencia a la colección "users"
      final usersCollection = _firestore.collection('users');
      
      // Verificar si el documento del usuario ya existe en la colección
      final userDoc = await usersCollection.doc(user.uid).get();
      
      if (!userDoc.exists) {
        // Crear un nuevo documento para el usuario autenticado
        await usersCollection.doc(user.uid).set({
          'name': user.displayName ?? 'Usuario sin nombre',
          'email': user.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Perfil de usuario creado en Firestore.");
      } else {
        print("El perfil de usuario ya existe en Firestore.");
      }
    } else {
      print("No hay un usuario autenticado.");
    }
  }
}
