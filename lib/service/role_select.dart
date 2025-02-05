import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleService {
  static Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final adminDoc = await FirebaseFirestore.instance
          .collection('roles')
          .doc(user.uid)
          .get();

      return adminDoc.exists;
    }
    return false;
  }
}