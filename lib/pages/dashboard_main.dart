import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/card_graphics.dart';
import 'package:testwithfirebase/graphics/data/line_chart_sample2.dart';
import 'package:testwithfirebase/graphics/data/pie_chart.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child:
      Column(
        children: [
          Row(
            children: [
                Expanded( child: CardGraphics(cardWidget: CustomPieChart(title: 'Cursos completados',)),),
                Expanded( child: CardGraphics(cardWidget: CustomPieChart(title: 'Cursos Añadidos',)),),
                Expanded(child: CardGraphics(cardWidget: CustomPieChart(title: 'Curso uso de facebook',)),)
              ],

          ),
          Row(
            children: [
              Expanded(child: CardGraphics(cardWidget: LineChartSample2())),
            ],
          )
        ],
      ),
    );
  }
}
