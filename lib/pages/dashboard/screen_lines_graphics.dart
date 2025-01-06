import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/graphics/lineChart/header_graphics.dart';
import '../../graphics/lineChart/graphic_line_chart.dart';

class ScreenLinesGraphics extends StatefulWidget {
  const ScreenLinesGraphics({super.key});

  @override
  State<ScreenLinesGraphics> createState() => _ScreenLinesGraphicsState();
}

class _ScreenLinesGraphicsState extends State<ScreenLinesGraphics> {
  bool _viewOtherGraphics = false; // Estado para alternar la vista

  void _toggleView() {
    setState(() {
      _viewOtherGraphics = !_viewOtherGraphics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BodyWidgets(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeaderGraphics(
            title: _viewOtherGraphics
                ? 'Empleados por Sare'
                : 'Empleados por Area',
            onToggleView: _toggleView,
            viewOtherGraphics: _viewOtherGraphics,
            viewOn: 'Ver por Sare',
            viewOff: 'Ver por Area'),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 300,
          child: GraphicLineChart(viewOtherGraphics: _viewOtherGraphics),
        )
      ],
    ));
  }
}
