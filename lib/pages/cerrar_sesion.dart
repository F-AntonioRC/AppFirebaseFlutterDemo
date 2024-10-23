import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/home_page.dart';
import '../auth/auth_service.dart';

class CerrarSesion extends StatefulWidget {
  const CerrarSesion({super.key});

  @override
  State<CerrarSesion> createState() => _CerrarSesionState();
}

void logout(BuildContext context) {
  final auth = AuthService();
  auth.signOut();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthGate()));// Cierra el diálogo después de cerrar sesión
}

class _CerrarSesionState extends State<CerrarSesion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Card(
          color: ligth,
          child: Column(
            children: [
              const ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  "¿Esta seguro que desea cerrar la Sesión?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
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
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                  const SizedBox(width: 10.0),
                  MyButton(
                    text: "Aceptar",
                    icon: const Icon(
                      Icons.check_circle_outlined,
                    ),
                    onPressed: () {
                      logout(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
