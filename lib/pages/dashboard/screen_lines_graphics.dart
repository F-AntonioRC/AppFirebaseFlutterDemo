import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/graphics/lineChart/header_graphics.dart';
import '../../graphics/lineChart/graphic_line_chart.dart';

  /// Pantalla que muestra gráficos de líneas para visualizar información de empleados.
  ///
  /// El widget alterna entre dos vistas distintas según el valor de [_viewOtherGraphics]:
  /// - Si es `false`, se muestra el gráfico "Empleados por Sare".
  /// - Si es `true`, se muestra el gráfico "Cursos completados por mes".
  ///
  /// La pantalla utiliza un encabezado (HeaderGraphics) que permite alternar la vista
  /// mediante un botón.

class ScreenLinesGraphics extends StatefulWidget {
  const ScreenLinesGraphics({super.key});

  @override
  State<ScreenLinesGraphics> createState() => _ScreenLinesGraphicsState();
}

class _ScreenLinesGraphicsState extends State<ScreenLinesGraphics> {
  /// Variable de estado que indica cuál vista de gráfico se está mostrando.
  /// Cuando es `false`, se muestra el gráfico de "Sare"; cuando es `true`, se muestra el de "Cursos completados por mes".
  bool _viewOtherGraphics = false;

  /// Función que alterna el valor de [_viewOtherGraphics] y actualiza la UI.
  void _toggleView() {
    setState(() {
      _viewOtherGraphics = !_viewOtherGraphics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BodyWidgets(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Encabezado que muestra el título del gráfico y un botón para alternar la vista.
              HeaderGraphics(
                  title: _viewOtherGraphics
                      ? 'Cursos completados por mes'
                      : 'Empleados por Sare',
                  onToggleView: _toggleView,
                  viewOtherGraphics: _viewOtherGraphics,
                  viewOn: 'Ver cursos completados por mes',
                  viewOff: 'Ver por Sare'),
              const SizedBox(height: 10.0),
              // Área que contiene el gráfico de líneas. Su altura se fija en 300.
              SizedBox(
                height: 500,
                child: GraphicLineChart(viewOtherGraphics: _viewOtherGraphics),
              )
            ],
          )),
    );
  }
}
