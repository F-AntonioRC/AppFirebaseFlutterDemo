import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: ligthBackground, primaryColor: ligth,
            primaryColorDark: darkBackground),
        debugShowCheckedModeBanner: false, home: const AuthGate());
  }
}
