import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/graphics/indicator.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key, required this.title});

  final String title;

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: ligth,
        child: Padding(padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Indicator(
                    color: Colors.blue,
                    text: 'Uno',
                    isSquare: false,
                    size: touchedIndex == 0 ? 18 : 16,
                    textColor: touchedIndex == 0 ? greenColor : darkBackground,
                  ),
                  Indicator(
                    color: Colors.green,
                    text: 'Dos',
                    isSquare: false,
                    size: touchedIndex == 1 ? 18 : 16,
                    textColor: touchedIndex == 1 ? greenColor : darkBackground,
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: showingSections(), // Asegurarte de generar solo 2 secciones.
                    ),
                  ),
                ),
              ),
            ],
          ),),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) { // Cambiar a 2 en lugar de 4
      final isTouched = i == touchedIndex;
      const color0 = Colors.blue;
      const color1 = Colors.green;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: color0,
            value: 75,
            title: '',
            radius: isTouched ? 80 : 65, // Ajustar radio si es tocado
            titlePositionPercentageOffset: 0.55,
            borderSide: isTouched
                ? const BorderSide(color: Colors.white, width: 6)
                : BorderSide(color: Colors.white.withOpacity(0)),
          );
        case 1:
          return PieChartSectionData(
            color: color1,
            value: 25,
            title: '',
            radius: isTouched ? 80 : 65, // Ajustar radio si es tocado
            titlePositionPercentageOffset: 0.55,
            borderSide: isTouched
                ? const BorderSide(color: Colors.white, width: 6)
                : BorderSide(color: Colors.white.withOpacity(0)),
          );
        default:
          throw Error();
      }
    });
  }
}
