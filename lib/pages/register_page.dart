import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class RegisterPage extends StatelessWidget {
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
        await auth.signUpWithEmailAndPassword(
            _emailController.text, _passwordController.text);
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
                            'Register',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 50),
                          MyTextfileld(
                            hindText: 'EMAIL',
                            icon: const Icon(Icons.email_outlined),
                            controller: _emailController,
                            obsecureText: false, keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          PasswordInput(controller: _passwordController, hindText: "PASSWORD", messageadd: false),
                          const SizedBox(height: 10),
                          PasswordInput(controller: _confirmPasswordController, hindText: "CONFIRM PASSWORD", messageadd: false),
                          const SizedBox(height: 10.0),
                          MyButton(
                            text: 'Registrar',
                            onPressed: () => register(context), icon: const Icon(Icons.arrow_forward),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes una cuenta? '),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          ' Inicia sesión',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade400),
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
