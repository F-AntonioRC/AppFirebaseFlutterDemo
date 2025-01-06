import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/graphics/pieChart/graphic_pie_chart.dart';
import 'package:testwithfirebase/graphics/lineChart/graphic_line_chart.dart';
import 'package:testwithfirebase/graphics/pieChart/main_pie_chart.dart';
import 'package:testwithfirebase/pages/dashboard/screen_lines_graphics.dart';
import '../../components/dashboard_components/card_graphics.dart';
import '../../graphics/data/pie_chart.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            MainPieChart(),
            Row(
              children: [
                Expanded(child: ScreenLinesGraphics())
              ],
            )
          ],
        ),
      ),
    );
  }
}
