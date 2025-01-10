import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _cupoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  void register(BuildContext context) async {
  final auth = AuthService();

  // Validar que las contraseñas coincidan
  if (_passwordController.text == _confirmPasswordController.text) {
    try {
      // Registrar el usuario en Firebase Auth
      final userCredential = await auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      String UID = userCredential.user!.uid;

      // Verificar si el CUPO existe en la colección de empleados
      final employeeSnapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .where('CUPO', isEqualTo: _cupoController.text)
          .get();

      if (employeeSnapshot.docs.isEmpty) {
        throw Exception('CUPO no encontrado en la base de datos.');
      }

      // Actualizar el registro del empleado con el UID
      final employeeId = employeeSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .update({
        'uid': UID,
        'email': _emailController.text,
      });

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Registro exitoso'),
          content: Text('Usuario registrado correctamente.'),
        ),
      );
    } catch (e) {
      // Manejar errores
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        ),
      );
    }
  } else {
    // Mostrar error si las contraseñas no coinciden
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Error'),
        content: Text('Las contraseñas no coinciden.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
              top: 10,
              left: 230,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: greenColor, shape: BoxShape.circle),
              )),
          Positioned(
              top: 10,
              left: 270,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                    color: greenColor, shape: BoxShape.circle),
              )),
          Positioned(
              bottom: 100,
              right: 280,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: greenColor, shape: BoxShape.circle),
              )),
          Positioned(
              bottom: 10,
              right: 320,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                    color: greenColor, shape: BoxShape.circle),
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.80,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              'Registrar',
                              style: TextStyle(
                                  fontSize: responsiveFontSize(context, 24),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Por favor ingresa tus datos',
                              style: TextStyle(
                                  fontSize: responsiveFontSize(context, 20)),
                            ),
                            const SizedBox(height: 15),
                            MyTextfileld(
                              hindText: 'CUPO',
                              icon: const Icon(Icons.person),
                              controller: _cupoController,
                              obsecureText: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            MyTextfileld(
                              hindText: 'CORREO ELECTRONICO',
                              icon: const Icon(Icons.email_outlined),
                              controller: _emailController,
                              obsecureText: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            PasswordInput(
                                controller: _passwordController,
                                hindText: "CONTRASEÑA",
                                messageadd: false),
                            const SizedBox(height: 10),
                            PasswordInput(
                                controller: _confirmPasswordController,
                                hindText: "CONFIRMAR CONTRASEÑA",
                                messageadd: false),
                            const SizedBox(height: 10.0),
                            MyButton(
                              text: 'Registrar',
                              onPressed: () => register(context),
                              icon: const Icon(Icons.arrow_forward), buttonColor: greenColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta? ',
                        style: TextStyle(
                            fontSize: responsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          'Inicia sesión',
                          style: TextStyle(
                              fontSize: responsiveFontSize(context, 20),
                              fontWeight: FontWeight.bold,
                              color: greenColor,
                              decoration: TextDecoration.underline,
                              decorationColor: greenColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
