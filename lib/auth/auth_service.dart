import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Intanciar autenticacion
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Obtener el correo del usuario actual
  String? getCurrentUserEmail() {
    User? user = auth.currentUser;
    return user?.email;
  }

  //Sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //reset password
  Future<void> sendPasswordReset(String email) async {
    try {
    await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign out
  Future<void> signOut() async {
    return await auth.signOut();
  }
}
