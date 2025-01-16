import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/components/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/backgruond_main.dart';
import 'package:testwithfirebase/service/auth_methods.dart';
import 'package:testwithfirebase/util/responsive.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _cupoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return BackgruondMain(
        formInit: SingleChildScrollView(
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
            style: TextStyle(fontSize: responsiveFontSize(context, 20)),
          ),
          const SizedBox(height: 15),
          MyTextfileld(
            hindText: 'CUPO',
            icon: const Icon(Icons.person),
            controller: _cupoController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          MyTextfileld(
            hindText: 'CORREO ELECTRONICO',
            icon: const Icon(Icons.email_outlined),
            controller: _emailController,
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
            onPressed: () => register(
                context,
                _cupoController.text,
                _emailController.text,
                _passwordController.text,
                _confirmPasswordController.text),
            icon: const Icon(Icons.add_task),
            buttonColor: greenColor,
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
    ));
  }
}
