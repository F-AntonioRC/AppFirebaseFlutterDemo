import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/auth/login_or_register.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/pages/backgruond_main.dart';
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
    return BackgruondMain(formInit: SingleChildScrollView(
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
            text: 'Enviar',
            onPressed: () async {
              await auth.sendPasswordReset(_emailController.text);
              if(context.mounted) {
                showCustomSnackBar(context, "Revisa tu correo para restablecer tu contraseña", greenColor);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOrRegister()));
              }
            },
            icon: const Icon(Icons.forward_to_inbox), buttonColor: greenColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),
              Text(
                '¿Tienes una cuenta?',
                style: TextStyle(
                    fontSize: responsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, MaterialPageRoute(builder: (context) => const LoginOrRegister()));
                },
                child: Text(
                  'Inicia Sesión',
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
    );

  }
}
