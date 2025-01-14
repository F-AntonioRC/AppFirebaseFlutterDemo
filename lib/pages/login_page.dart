import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/backgruond_main.dart';
import 'package:testwithfirebase/service/auth_methods.dart';
import '../util/responsive.dart';
import 'main_pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              MouseRegion(
                onEnter: (_) => FocusScope.of(context).unfocus(),
                child: MyTextfileld(
                  hindText: 'Correo',
                  icon: const Icon(Icons.email_outlined),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
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
                onPressed: () =>
                    login(context, _emailController.text,
                        _passwordController.text),
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
                    onTap: widget.onTap,
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