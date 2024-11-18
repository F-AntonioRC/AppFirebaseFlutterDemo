import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/home_page.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../auth/auth_service.dart';

class CerrarSesion extends StatefulWidget {
  const CerrarSesion({super.key});

  @override
  State<CerrarSesion> createState() => _CerrarSesionState();
}

void logout(BuildContext context) {
  final auth = AuthService();
  auth.signOut();
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const AuthGate())); // Cierra el diálogo después de cerrar sesión
}

class _CerrarSesionState extends State<CerrarSesion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: darkBackground,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "¿Esta seguro que desea cerrar la Sesión?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFontSize(context, 20),
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: "Cancelar",
                      icon: const Icon(
                        Icons.cancel_outlined,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      }, buttonColor: Colors.red,
                    ),
                    const SizedBox(width: 10.0),
                    MyButton(
                      text: "Aceptar",
                      icon: const Icon(
                        Icons.check_circle_outlined,
                      ),
                      onPressed: () {
                        logout(context);
                      }, buttonColor: greenColor,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
