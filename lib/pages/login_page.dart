import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/backgruond_main.dart';
import '../util/responsive.dart';
import 'forgot_password.dart';

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
      if (context.mounted) {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text(e.toString()),
              )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgruondMain(
        formInit: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Iniciar Sesión',
            style: TextStyle(
                fontSize: responsiveFontSize(context, 24),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          MyTextfileld(
            hindText: 'Correo',
            icon: const Icon(Icons.email_outlined),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15.0),
          PasswordInput(
            controller: _passwordController,
            hindText: "Contraseña",
            messageadd: true,
          ),
          const SizedBox(height: 20.0),
          MyButton(
            text: 'Login',
            onPressed: () => login(context),
            icon: const Icon(Icons.login),
            buttonColor: greenColor,
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
              child: Text(
                "Olvide mi contraseña",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: responsiveFontSize(context, 18),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              Text(
                '¿No tienes una cuenta? ',
                style: TextStyle(
                    fontSize: responsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onTap,
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
    ));
  }
}
