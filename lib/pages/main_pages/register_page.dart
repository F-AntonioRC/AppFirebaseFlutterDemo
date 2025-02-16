import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/components/formPatrts/my_textfileld.dart';
import 'package:testwithfirebase/components/formPatrts/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/components/formPatrts/backgruond_main.dart';
import 'package:testwithfirebase/service/auth_methods.dart';
import 'package:testwithfirebase/util/responsive.dart';

/// Pantalla de registro de usuario.
///
/// Este widget permite al usuario registrarse ingresando su cupo, correo electrónico,
/// contraseña y confirmación de contraseña. Además, incluye un enlace para dirigirse a la pantalla
/// de inicio de sesión si ya se tiene una cuenta.
///
/// Los datos ingresados se envían a la función [register] para proceder con el proceso de registro.

class RegisterPage extends StatelessWidget {
  final TextEditingController _cupoController =
      TextEditingController(); // Controlador para el CUPO.
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para el email.
  final TextEditingController _passwordController =
      TextEditingController(); // Controlador para la contraseña.
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Controlador para verificar la contraseña.

  // Callback opcional que se ejecuta cuando el usuario pulsa el enlace para iniciar sesión.
  final void Function()? onTap;

  // Constructor del widget [RegisterPage].
  RegisterPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Widget personalizado para el fondo de la pantalla.
    return BackgruondMain(
        // Se utiliza SingleChildScrollView para evitar desbordamientos en pantallas pequeñas.
        formInit: SingleChildScrollView(
      child: Column(
        children: [
          // Título principal de la pantalla de registro.
          Text(
            'Registrar',
            style: TextStyle(
                fontSize: responsiveFontSize(context, 24),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Instrucción para que el usuario ingrese sus datos.
          Text(
            'Por favor ingresa tus datos',
            style: TextStyle(fontSize: responsiveFontSize(context, 20)),
          ),
          const SizedBox(height: 15),
          // Widgets personalizados para registrar los datos
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
              messageadd: true),
          const SizedBox(height: 10.0),
          // Botón para enviar la solicitud de registro.
          MyButton(
            text: 'Registrar',
            onPressed: () => register(
                context,
                _cupoController.text,
                _emailController.text,
                _passwordController.text,
                _confirmPasswordController.text),
            icon: const Icon(Icons.add_task),
            buttonColor: greenColorLight,
          ),
          // Sección con el enlace para ir a la pantalla de inicio de sesión.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta? ',
                    style: TextStyle(
                        fontSize: responsiveFontSize(context, 18),
                        fontWeight: FontWeight.bold),
                  ),
                  // Al pulsar este enlace se ejecuta la función callback [onTap] para navegar a la
                  // pantalla de login.
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Inicia sesión',
                      style: TextStyle(
                          fontSize: responsiveFontSize(context, 18),
                          fontWeight: FontWeight.bold,
                          color: greenColorLight,
                          decoration: TextDecoration.underline,
                          decorationColor: wineDark),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ));
  }
}
