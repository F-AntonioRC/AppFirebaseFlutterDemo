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
          child: GraphicPieChart(graphicFunction: getDataEmployeeByDependency(), title: 'Empleados por Dependencia',),
        )),
        Expanded(child:  SizedBox(
          height: 400,
          child: GraphicPieChart(graphicFunction: getDataByTrimestre(), title: 'Cursos por Trimestre'),
        ))
      ],
    );

  }
}
