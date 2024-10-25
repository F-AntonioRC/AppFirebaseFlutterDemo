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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  // Función para cambiar el tema
  void toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: ligthBackground,
          primaryColor: ligth,
          appBarTheme: const AppBarTheme(
            backgroundColor: ligth
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: dark,
          primaryColor: darkBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: dark
          ),
        ),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, //CAMBIAR EL TEMA
        debugShowCheckedModeBanner: false, home: const AuthGate());
  }
}
