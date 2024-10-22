import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  void register(BuildContext context) async {
    //auth service
    final auth = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        //await auth.signUpWithEmailAndPassword(
            //_emailController.text, _passwordController.text);

        // Registro del usuario en Firebase Auth
        final userCredential = await auth.signUpWithEmailAndPassword(
            _emailController.text, _passwordController.text);

        String UID = userCredential.user!.uid;
        String Id = randomAlphaNumeric(3);

        // Guarda los datos del empleado en Firestore
        await FirebaseFirestore.instance.collection('Employee').doc(UID).set({
          
          'Nombre': _nameController.text,
          'email': _emailController.text,
          'uid': UID,
          'Estado': 'Activo'
        });

      } catch (e) {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text(e.toString()),
              )),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: ((context) => const AlertDialog(
              title: Text('Las contraselas no coinciden'),
            )),
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Card(
                      child: Padding(padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'Registrar',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          MyTextfileld(
                            hindText: 'Nombre Completo',
                            icon: const Icon(Icons.person),
                            controller: _nameController,
                            obsecureText: false, keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          MyTextfileld(
                            hindText: 'Correo',
                            icon: const Icon(Icons.email_outlined),
                            controller: _emailController,
                            obsecureText: false, keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          PasswordInput(controller: _passwordController, hindText: "PASSWORD", messageadd: false),
                          const SizedBox(height: 10),
                          PasswordInput(controller: _confirmPasswordController, hindText: "CONFIRM PASSWORD", messageadd: false),
                          const SizedBox(height: 20.0),
                          MyButton(
                            text: 'Registrar',
                            onPressed: () => register(context), icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes una cuenta? ', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: onTap,
                        child: const Text(
                          ' Inicia sesión',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: greenColor),

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
