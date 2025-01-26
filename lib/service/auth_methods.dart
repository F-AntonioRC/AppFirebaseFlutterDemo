import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';

import '../auth/login_or_register.dart';
import '../dataConst/constand.dart';

/// Esta función de Dart maneja el proceso de inicio de sesión validando los campos de entrada e 
/// intentando iniciar sesión con correo electrónico y contraseña usando un AuthService.
/// 
/// Argumentos:
/// contexto (BuildContext): El parámetro `BuildContext context` en la función `login` se usa para
/// proporcionar el contexto del widget actual en el árbol de widgets. Se usa comúnmente para acceder
/// a información sobre la ubicación del widget en el árbol de widgets y para mostrar elementos de la 
/// IU como SnackBars, diálogos, etc.
/// correo electrónico (String): El parámetro `email` en la función `login` es una cadena que 
/// representa la dirección de correo electrónico ingresada por el usuario para iniciar sesión.
/// contraseña (String): El parámetro `password` en la función `login` es una cadena que representa
/// la contraseña ingresada por el usuario para la autenticación. Se usa para intentar iniciar sesión con la
/// combinación de correo electrónico y contraseña proporcionada.
/// 
/// Retorna:
/// Si el correo electrónico o la contraseña están vacíos, se muestra una snackbar personalizado
/// con un mensaje "Por favor, complete todos los campos." en color rojo usando la función 
/// `showCustomSnackBar` y luego la función retorna sin realizar la operación de inicio de sesión.
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

/// La función `register` en Dart registra a un usuario con correo electrónico y contraseña, almacena su información
/// en Firebase Firestore y maneja errores con mensajes de error personalizados y registro de Sentry.
/// 
/// Argumentos:
/// cupo (String): El parámetro `cupo` en la función `register` representa un identificador
/// específico relacionado con el usuario. Se almacena en la base de datos de Firestore bajo el
/// campo 'CUPO' para el documento de usuario. Es importante tener en cuenta que se recorta antes 
/// de guardar para eliminar cualquier espacio al inicio o final.
/// email (String): El parámetro `email` en la función `register` es una cadena que representa la
/// dirección de correo electrónico del usuario que se está registrando. Se utiliza como parte del 
/// proceso de registro del usuario para crear una nueva cuenta con la dirección de correo electrónico 
/// proporcionada.
/// password (String): El parámetro `password` en la función `register` es una cadena que representa
/// la contraseña ingresada por el usuario durante el proceso de registro. Se utiliza para crear una 
/// nueva cuenta de usuario con la dirección de correo electrónico proporcionada.
/// confirmPassword (Cadena): El parámetro `confirmPassword` en la función `register` se utiliza para
/// almacenar la contraseña confirmada ingresada por el usuario durante el proceso de registro. 
/// Este parámetro se compara con el parámetro `password` para garantizar que el usuario haya ingresado 
/// la misma contraseña correctamente dos veces antes de continuar con el registro. 
/// Si las contraseñas no coinciden muestra un mensaje con la función `showCustomSnackBar`.
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

/// La función `sendPasswordReset` en Dart envía un correo electrónico de restablecimiento de 
/// contraseña a la dirección de correo electrónico proporcionada, manejando errores y mostrando 
/// mensajes apropiados.
/// 
/// Argumentos:
/// contexto (BuildContext): el parámetro `BuildContext` en la función `sendPasswordReset` se usa
/// para proporcionar el contexto del widget actual en el árbol de widgets. Se usa normalmente para 
/// mostrar elementos de la interfaz de usuario como SnackBars, diálogos o navegar a diferentes 
/// pantallas. 
/// Correo electrónico (String): el parámetro `email` en la función `sendPasswordReset` 
/// es una cadena que representa la dirección de correo electrónico a la que se enviará el enlace 
/// de restablecimiento de contraseña. Se usa para enviar el correo electrónico de restablecimiento 
/// de contraseña a la dirección de correo electrónico especificada para que el usuario restablezca 
/// su contraseña.
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
