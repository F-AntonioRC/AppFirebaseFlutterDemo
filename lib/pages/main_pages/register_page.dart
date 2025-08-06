import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
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
  final _formKey = GlobalKey<FormState>(); //Controlador del Formulario

  // Callback opcional que se ejecuta cuando el usuario pulsa el enlace para iniciar sesión.
  final void Function()? onTap;

  // Constructor del widget [RegisterPage].
  RegisterPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Widget personalizado para el fondo de la pantalla.
    return BackgruondMain(
        // Se utiliza SingleChildScrollView para evitar desbordamientos en pantallas pequeñas.
        formInit: SingleChildScrollView(
            child: Form(
      key: _formKey,
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
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El CUPO es obligatorio';
              }
              if (value.trim().length != 6) {
                return 'El CUPO debe tener 6 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          MyTextfileld(
            hindText: 'CORREO ELECTRONICO',
            icon: const Icon(Icons.email_outlined),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El correo es obligatorio';
              }
              if (!value.trim().endsWith('@becasbenitojuarez.gob.mx')) {
                return 'Debe usar un correo institucional: @becasbenitojuarez.gob.mx';
              }
              return null;
            },
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                register(context, _cupoController.text, _emailController.text,
                    _passwordController.text, _confirmPasswordController.text);
              } else {
                showCustomSnackBar(
                    context, 'Revisa los campos marcados', Colors.red);
              }
            },
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
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : wineLight,
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
    )));
  }
}
