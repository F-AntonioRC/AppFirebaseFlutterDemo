import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/auth/login_or_register.dart';
import 'package:testwithfirebase/pages/register_page.dart';
import '../components/my_button.dart';
import '../components/my_textfileld.dart';
import '../dataConst/constand.dart';
import '../util/responsive.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = AuthService();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ligthBackground,
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      'Restablecer contraseña',
                                      style: TextStyle(
                                          fontSize: responsiveFontSize(context, 24),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Por favor ingresa tu correo',
                                      style: TextStyle(
                                          fontSize: responsiveFontSize(context, 18)),
                                    ),
                                    const SizedBox(height: 15),
                                    MyTextfileld(
                                      hindText: 'Correo',
                                      icon: const Icon(Icons.email_outlined),
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 15.0),
                                    MyButton(
                                      text: 'Aceptar',
                                      onPressed: () async {
                                       await auth.sendPasswordReset(_emailController.text);
                                       ScaffoldMessenger.of(context).
                                       showSnackBar(const SnackBar(content: Text("Revisa tu correo para restablecer tu contraseña")));
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOrRegister()));
                                       },
                                      icon: const Icon(Icons.arrow_forward), buttonColor: greenColor,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40.0),
                          Text(
                            '¿No tienes una cuenta? ',
                            style: TextStyle(
                                fontSize: responsiveFontSize(context, 20),
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                            },
                            child: Text(
                              'Registrate',
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
