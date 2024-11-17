import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkUI() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final adminDoc = await FirebaseFirestore.instance
        .collection('roles') // Nombre de la colección
        .doc(user.uid) // UID del usuario
        .get();

    return adminDoc.exists; // Devuelve true si el documento existe
  }
  return false; // Si no hay usuario autenticado o no está en la colección
}