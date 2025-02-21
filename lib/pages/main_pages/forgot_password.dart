import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/login_or_register.dart';
import 'package:testwithfirebase/components/formPatrts/backgruond_main.dart';
import 'package:testwithfirebase/service/auth_methods.dart';
import '../../components/formPatrts/my_button.dart';
import '../../components/formPatrts/my_textfileld.dart';
import '../../dataConst/constand.dart';
import '../../util/responsive.dart';

  /// Pantalla para restablecer la contraseña.
  ///
  /// Esta pantalla permite al usuario ingresar su correo electrónico para
  /// solicitar un enlace de restablecimiento de contraseña. Además, brinda la opción
  /// de regresar a la pantalla de inicio de sesión o registro.

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Controlador para el campo de correo electrónico.
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Widget personalizado para el fondo de la pantalla.
    return BackgruondMain(
      // Utiliza un SingleChildScrollView para evitar problemas de desbordamiento
      // en pantallas pequeñas.
      formInit: SingleChildScrollView(
        child: Column(
          children: [
            // Título principal de la pantalla.
            Text(
              'Restablecer contraseña',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Instrucción al usuario.
            Text(
              'Por favor ingresa tu correo',
              style: TextStyle(fontSize: responsiveFontSize(context, 18)),
            ),
            const SizedBox(height: 15.0),
            // Widget personalizado de texto para ingresar el correo electrónico.
            MyTextfileld(
              hindText: 'Correo',
              icon: const Icon(Icons.email_outlined),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15.0),
            // Botón para enviar la solicitud de restablecimiento de contraseña.
            MyButton(
              text: 'Enviar',
              onPressed: () =>
                  sendPasswordReset(context, _emailController.text),
              icon: const Icon(Icons.forward_to_inbox),
              buttonColor: greenColorLight,
            ),
            // Sección que permite al usuario regresar a la pantalla de inicio de sesión.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                Text(
                  '¿Tienes una cuenta? ',
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Navega de regreso a la pantalla de inicio de sesión o registro.
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginOrRegister()));
                  },
                  child: Text(
                    '<- Regresar',
                    style: TextStyle(
                        fontSize: responsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: theme.brightness ==  Brightness.dark
                        ? Colors.white
                        : greenColorLight,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.brightness ==  Brightness.dark
                            ? greenColorLight
                            : wineLight,),
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