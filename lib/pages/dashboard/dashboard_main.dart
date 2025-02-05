import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/graphics/pieChart/main_pie_chart.dart';
import 'package:testwithfirebase/pages/dashboard/screen_lines_graphics.dart';

  /// La clase `DashboardMain` es un StatelessWidget que utiliza los Widgets personalizados [MainPieChart]
  /// y [ScreenLinesGraphics] para mostrar en la UI los datos graficados que se han seleccionado.
class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            MainPieChart(), // Widget personalizado para las graficas circulares.
            Row(
              children: [
                Expanded(child:
                // Widget personalizado para las graficas de lineas.
                ScreenLinesGraphics())
              ],
            )
          ],
        ),
      ),
    );
  }
}
