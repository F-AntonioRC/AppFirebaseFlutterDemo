import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/graphics/pieChart/graphic_pie_chart.dart';
import 'package:testwithfirebase/graphics/pieChart/pie_chart_service.dart';

class MainPieChart extends StatelessWidget {
  const MainPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: SizedBox(
          height: 400,
          child: GraphicPieChart(graphicFunction: getDataEmployeeForGraphic('Cursos', 'Dependencia'), title: 'Cursos por Dependencia',),
        )),
        Expanded(child:  SizedBox(
          height: 400,
          child: GraphicPieChart(graphicFunction: getDataEmployeeForGraphic('Cursos', 'Trimestre'), title: 'Cursos por Trimestre'),
        ))
      ],
    );

  }
  
}
