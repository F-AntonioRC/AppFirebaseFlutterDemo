import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/formPatrts/image_background_main.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../../dataConst/constand.dart';

/// Este Widget representa la estructura principal de fondo para las pantallas de la aplicación.
///
/// Este widget envuelve un contenido (formulario u otro) dentro de un Scaffold con un fondo
/// y elementos decorativos (círculos de color) posicionados estratégicamente. Además, centra el
/// contenido principal en la pantalla y adapta su ancho según el tamaño de la pantalla.

class BackgruondMain extends StatelessWidget {
  // Widget que se mostrará como contenido principal dentro del layout.
  final Widget formInit;

  // Constructor del widget [BackgruondMain].
  const BackgruondMain({super.key, required this.formInit});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    // Establecer el widthFactor dependiendo de si se trata de una pantalla móvil o no.
    // Si el ancho es menor a 600 (pantalla móvil), se usará el 90% del ancho,
    // de lo contrario, se utilizará el 60%.
    double widthFactor = screenWidth < 600 ? 0.90 : 0.60;

    return Scaffold(
      backgroundColor: ligthBackground,
      body: SafeArea(
          child: Stack(
            children: [
              // Elementos decorativos: círculos posicionados en distintos lugares.
              Positioned(
                  top: 10,
                  left: 230,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: greenColor, shape: BoxShape.circle),
                  )),
              Positioned(
                  top: 10,
                  left: 270,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                        color: greenColor, shape: BoxShape.circle),
                  )),
              Positioned(
                  bottom: 100,
                  right: 280,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: greenColor, shape: BoxShape.circle),
                  )),
              Positioned(
                  bottom: 10,
                  right: 320,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        color: greenColor, shape: BoxShape.circle),
                  )),
              // Contenido principal centrado en la pantalla.
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagen de fondo o logo de la aplicación, ajustada a un 40% del ancho disponible.
                    FractionallySizedBox(
                      widthFactor: Responsive.isMobile(context) ? 0.8 : 0.5,
                      child: const ImageBackgroundMain(),
                    ),
                    const SizedBox(height: 20.0,),
                    // Área que contiene el formulario o widget principal,
                    // cuyo ancho se ajusta en función del tamaño de la pantalla.
                    FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: BodyWidgets(body: formInit),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}