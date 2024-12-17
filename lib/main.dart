import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/firebase_options.dart';
import 'package:testwithfirebase/providers/theme.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()), //Provier del tema
        ChangeNotifierProvider(create: (_) => EditProvider()), //Provider del employee
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
        theme: themeNotifier.isDarkTheme ? darkTheme : lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate());
  }
}
