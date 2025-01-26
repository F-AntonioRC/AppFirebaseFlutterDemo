import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/auth/auth_gate.dart';
import 'package:testwithfirebase/firebase_options.dart';
import 'package:testwithfirebase/providers/theme.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SentryFlutter.init((options) {
    options.dsn = 'https://fc5884625a402f576572138cf77ae88c@o4508671006867456.ingest.us.sentry.io/4508671015649280';
    options.tracesSampleRate = 1.0; //CAPTURA EL 100% DE LAS TRANSACCIONES EN PRODUCCION
    options.profilesSampleRate = 1.0; //CAPURA EL 100% DE LAS TRANSACCIONES RASTREADAS
  });

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
