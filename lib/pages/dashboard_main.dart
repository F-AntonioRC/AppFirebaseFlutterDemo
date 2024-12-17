import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/graphics/data/line_chart_sample2.dart';

import '../components/dashboard_components/card_graphics.dart';
import '../graphics/data/pie_chart.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: CardGraphics(cardWidget: CustomPieChart(title: 'Cursos añadidos',)),),
                Expanded(child: CardGraphics(cardWidget: CustomPieChart(title: 'Cursos Completados',)),),
                Expanded(child: CardGraphics(cardWidget: CustomPieChart(title: 'Empleados Activos',)),)
              ],
            ),
            Row(
              children: [
                Expanded(child: LineChartSample2())
              ],
            )
          ],
        ),
      ),
    );
  }
}
