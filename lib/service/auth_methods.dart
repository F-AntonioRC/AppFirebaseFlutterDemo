import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';

import '../auth/login_or_register.dart';
import '../dataConst/constand.dart';

Future<void> login(BuildContext context, String email, String password) async {
  final authService = AuthService();

  // Validar campos
  if (email.isEmpty || password.isEmpty) {
    showCustomSnackBar(
        context, 'Por favor, complete todos los campos.', Colors.red);
    return;
  }
  // Intentar login
  try {
    await authService.signInWithEmailPassword(email.trim(), password.trim());
  } catch (e) {
    if (context.mounted) {
      showCustomSnackBar(context, "Error $e", Colors.red);
    }
  }
}

Future<void> register(BuildContext context, String cupo, String email,
    String password, String confirmPassword) async {
  final authService = AuthService();

  if (password.trim() == confirmPassword.trim()) {
    try {
      final userCredential =
          await authService.signUpWithEmailAndPassword(email, password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('User').doc(uid).set({
        'CUPO': cupo.trim(),
        'email' : email.trim(),
        'uid' : uid
      });
    } catch (e, stackTrace) {
      if(context.mounted) {
        showCustomSnackBar(context, "Error: $e", Colors.red);
      }
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('operation', 'Register');
          scope.setContexts('operation_context', cupo);
        },
      );
    }
  } else {
    showCustomSnackBar(context, "Verifique la contraseña", Colors.red);
  }
}

Future<void> sendPasswordReset(BuildContext context, String email) async {
  final authService = AuthService();
  // Validar el correo
  if (email.isEmpty) {
    showCustomSnackBar(
        context, "Por favor ingresa un correo válido", Colors.red);
    return;
  }

  try {
    await authService.sendPasswordReset(email.trim());
    if (context.mounted) {
      showCustomSnackBar(context,
          "Revisa tu correo para restablecer tu contraseña", greenColor);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginOrRegister()));
    }
  } catch (e, stackTrace) {
    if (context.mounted) {
      showCustomSnackBar(context, 'Error: $e', Colors.red);
    }
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('operation', 'Send password Reset');
          scope.setContexts('operation_context', email);
      },
    );
  }
}
