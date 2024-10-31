import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

import '../util/responsive.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    //try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text(e.toString()),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ligthBackground,
      body: SafeArea(
          child:  Stack(
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
                              child:
                              Padding(padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(fontSize: responsiveFontSize(context, 24), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        'Por favor ingresa tus datos',
                                        style: TextStyle(fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 30.0),
                                      MyTextfileld(
                                        hindText: 'Correo',
                                        icon: const Icon(Icons.email_outlined),
                                        controller: _emailController,
                                        obsecureText: false, keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 20.0),
                                      PasswordInput(controller: _passwordController, hindText: "Contraseña", messageadd: true, ),
                                      const SizedBox(height: 20.0),
                                      MyButton(
                                        text: 'Login',
                                        onPressed: () => login(context), icon: const Icon(Icons.arrow_forward),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40.0),
                            Text('¿No estas registrado? ', style: TextStyle(fontSize: responsiveFontSize(context, 20), fontWeight: FontWeight.bold),),
                            GestureDetector(
                              onTap: onTap,
                              child: Text(
                                ' Registrate Ahora',
                                style: TextStyle(
                                  fontSize: responsiveFontSize(context, 20),
                                    fontWeight: FontWeight.bold,
                                    color: greenColor),
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
