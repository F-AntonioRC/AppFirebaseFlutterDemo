import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/configuration/card_colors.dart';
import 'package:testwithfirebase/components/configuration/theme_color.dart';
import 'package:testwithfirebase/components/configuration/up_file_card.dart';

  /// La clase `Configuration` es un StatefulWidget que muestra los elementos correspondientes a la
  /// pantalla de configuración de la UI, mediante un Row se llama a los Widgets personalizados.
class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeColor(), // Widget personalizado para el tema de la interfaz
        CardColors(), // Widget personalizado que muestra los colores del tema
        UpFileCard(), // Widget personalizado para la carga de registros en la base de datos
      ],
    ),);
  }
}
