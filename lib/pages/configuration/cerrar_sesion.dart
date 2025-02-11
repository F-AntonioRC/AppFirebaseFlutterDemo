import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../../auth/auth_service.dart';

  /// La clase `CerrarSesion` es un StatefulWidget encargado del logout de la sesión, ademas en caso
  /// de cancelar la opción se redigira a la pantalla home o principal dependiendo del tipo de
  /// usuario.
class CerrarSesion extends StatefulWidget {
  const CerrarSesion({super.key});

  @override
  State<CerrarSesion> createState() => _CerrarSesionState();
}

 // Función para cerrar la sesión de firebase, redirige a la pantalla para iniciar sesión
void _logout(BuildContext context) {
  final auth = AuthService();
  auth.signOut();
  // Cierra el diálogo después de cerrar sesión
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const AuthGate() 
      )
  ); 
}

class _CerrarSesionState extends State<CerrarSesion> {
  @override
  Widget build(BuildContext context) {
    return BodyWidgets(body: Column(
      children: [
        // Titulo de la acción
        ListTile(
          title: Text(
            "¿Esta seguro que desea cerrar la Sesión?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold),
          ),
        ),
        // Botones del card
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              text: "Cancelar",
              icon: const Icon(
                Icons.cancel_outlined,
              ),
              onPressed: () {
                // Redirigir a la pantalla correspondiente en caso de cancelar
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthGate()));
              }, buttonColor: Colors.red,
            ),
            const SizedBox(width: 10.0),
            MyButton(
              text: "Aceptar",
              icon: const Icon(
                Icons.check_circle_outlined,
              ),
              onPressed: () {
                // Función para cerrar la sesión
                _logout(context);
              }, buttonColor: greenColorLight,
            )
          ],
        )
      ],
    ));
  }
}
