import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../indicator.dart';
import '../model_chart.dart';

class GraphicPieChart extends StatefulWidget {
  final String title;
  final Future<List<ChartData>> graphicFunction;

  const GraphicPieChart({super.key, required this.graphicFunction, required this.title});

  @override
  State<GraphicPieChart> createState() => _GraphicPieChartState();
}

class _GraphicPieChartState extends State<GraphicPieChart> {
  late Future<List<ChartData>> _futureChartData;
  int touchedIndex = -1; // Índice de la sección tocada

  @override
  void initState() {
    super.initState();
    _futureChartData = widget.graphicFunction;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartData>>(
      future: _futureChartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final chartData = snapshot.data!;
          return BodyWidgets(body:
          Column(
            children: [
              Text(widget.title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveFontSize(context, 18)
              ),),
              const SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: chartData.map((data) {
                  final index = chartData.indexOf(data);
                  return Indicator(
                    key: ValueKey(data.campo),
                    color: _getColor(index),
                    text: data.campo,
                    isSquare: false,
                    size: touchedIndex == index ? 18 : 16,
                    textColor: touchedIndex == index
                        ? darkBackground
                        : ligthBackground,
                  );
                }).toList(),
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    startDegreeOffset: 180,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 1,
                    centerSpaceRadius: 0,
                    sections: _generateSections(chartData),
                  ),
                ),
              ),
            ],
          ));
        } else {
          return const Center(child: Text('No hay datos disponibles'));
        }
      },
    );
  }

  List<PieChartSectionData> _generateSections(List<ChartData> data) {
    final total = data.fold<int>(0, (add, item) => add + item.valor);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final chartData = entry.value;
      final isTouched = index == touchedIndex;
      final double percentage = (chartData.valor / total) * 100;

      return PieChartSectionData(
        color: _getColor(index),
        value: chartData.valor.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: isTouched ? 120 : 100,
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched
            ? const BorderSide(color: Colors.white, width: 6)
            : BorderSide(color: Colors.white.withAlpha((0.3 * 255).toInt())),
      );
    }).toList();
  }

  Color _getColor(int index) {
    // Devuelve colores predefinidos o generados dinámicamente
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.yellow, Colors.purple];
    return colors[index % colors.length];
  }
}
