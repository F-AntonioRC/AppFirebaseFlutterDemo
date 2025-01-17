import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/components/image_background_main.dart';
import '../dataConst/constand.dart';

class BackgruondMain extends StatelessWidget {
  final Widget formInit;

  const BackgruondMain({super.key, required this.formInit});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    // Establecer widthFactor dependiendo de si es una pantalla móvil o no
    double widthFactor = screenWidth < 600 ? 0.90 : 0.60;

    return Scaffold(
      backgroundColor: ligthBackground,
      body: SafeArea(
          child: Stack(
            children: [
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FractionallySizedBox(
                      widthFactor: 0.4,
                      child: ImageBackgroundMain(),
                    ),
                    const SizedBox(height: 20.0,),
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
