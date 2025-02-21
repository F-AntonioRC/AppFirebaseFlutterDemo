import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/components/formPatrts/my_textfileld.dart';
import 'package:testwithfirebase/components/formPatrts/password_input.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/components/formPatrts/backgruond_main.dart';
import 'package:testwithfirebase/service/auth_methods.dart';
import '../../util/responsive.dart';
import 'forgot_password.dart';

  /// Pantalla de inicio de sesión.
  ///
  /// Este widget muestra un formulario para que el usuario ingrese su correo y contraseña,
  /// permitiéndole iniciar sesión. Además, incluye enlaces para recuperar la contraseña en
  /// caso de olvido y para dirigirse a la pantalla de registro (a través de la función [onTap]).

class LoginPage extends StatefulWidget {
  // Función callback que se ejecuta cuando se pulsa el enlace de registro.
  final void Function()? onTap;
  // Constructor del widget.
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controlador para el campo de correo electrónico.
  final TextEditingController _emailController = TextEditingController();

  // Controlador para el campo de contraseña.
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Se liberan los recursos de los controladores al destruir el widget.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget personalizado para el fondo de la pantalla.
    return BackgruondMain(
      // Se utiliza SingleChildScrollView para evitar overflow en pantallas pequeñas.
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
              // Campo de entrada para el correo electrónico.
              MouseRegion(
                // Al ingresar el ratón se desvanece el foco para evitar que se active el teclado.
                onEnter: (_) => FocusScope.of(context).unfocus(),
                child: MyTextfileld(
                  hindText: 'Correo',
                  icon: const Icon(Icons.email_outlined),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 15.0),
              // Campo de entrada para la contraseña, utilizando un widget personalizado.
              PasswordInput(
                controller: _passwordController,
                hindText: "Contraseña",
                messageadd: true, // Valor que se utiliza para mostrar mensajes adicionales.
              ),
              const SizedBox(height: 20.0),
              // Botón para iniciar sesión.
              MyButton(
                text: 'Login',
                onPressed: () =>
                    login(context, _emailController.text,
                        _passwordController.text),
                icon: const Icon(Icons.login),
                buttonColor: greenColorLight,
              ),
              const SizedBox(
                height: 10,
              ),
              // Enlace para recuperar la contraseña en caso de olvido.
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
                        decorationColor: wineDark),
                  )),
              // Enlace para ir a la pantalla de registro.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta? ',
                        style: TextStyle(
                            fontSize: responsiveFontSize(context, 18),
                            fontWeight: FontWeight.bold),
                      ),
                      // Al pulsar se ejecuta el callback [onTap] definido en el widget.
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Registrate',
                          style: TextStyle(
                              fontSize: responsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                              color: pantone1255,
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