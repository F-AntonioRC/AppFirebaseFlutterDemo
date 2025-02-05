import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/graphics/pieChart/graphic_pie_chart.dart';
import 'package:testwithfirebase/graphics/pieChart/pie_chart_service.dart';

  /// La clase `MainPieChart` es un StatelessWidget que muestra los Widgets personalizados GraphicPieChart
  /// con los valores que se deseen graficar.
class MainPieChart extends StatelessWidget {
  const MainPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // El Widget personalizado esta dentro de un SizedBox para limitar su tamaño y esta envuelto
        // en un Expanded para que ocupe el espacio disponible.
        Expanded(child: SizedBox(
          height: 400,
          child: GraphicPieChart(graphicFunction: getDataEmployeeForGraphic('Cursos', 'Dependencia'), title: 'Cursos por Dependencia',),
        )),
        // El Widget personalizado esta dentro de un SizedBox para limitar su tamaño y esta envuelto
        // en un Expanded para que ocupe el espacio disponible.
        Expanded(child:  SizedBox(
          height: 400,
          child: GraphicPieChart(graphicFunction: getDataEmployeeForGraphic('Cursos', 'Trimestre'), title: 'Cursos por Trimestre'),
        ))
      ],
    );

  }
  
}
