//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import '../../util/responsive.dart';
import '../model_chart.dart';
import 'line_chart_service.dart';

class GraphicLineChart extends StatefulWidget {
  final bool viewOtherGraphics; // Parámetro para alternar vista

  const GraphicLineChart({super.key, required this.viewOtherGraphics});

  @override
  State<GraphicLineChart> createState() => _GraphicLineChartState();
}

class _GraphicLineChartState extends State<GraphicLineChart> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  final LineChartService _chartLineService = LineChartService();
  List<FlSpot> _dataPoints = []; // Lista de puntos para el gráfico
  Map<int, String> _xLabels = {}; // Etiquetas para el eje X
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final String dataField = widget.viewOtherGraphics ? 'Activo' : 'Inactivo';
    try {
      // Llama a la función obtenerDatos()
      List<ChartData> chartData =
          await _chartLineService.getDataBySelect('Courses', dataField);

      // Transforma los datos categóricos en puntos numéricos
      List<FlSpot> dataPoints = [];
      Map<int, String> xLabels = {}; // Mapa para las etiquetas del eje X

      for (int i = 0; i < chartData.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), chartData[i].valor.toDouble()));
        xLabels[i] =
            chartData[i].campo; // Asignamos la etiqueta correspondiente
      }

      setState(() {
        _dataPoints = dataPoints;
        _xLabels = xLabels;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Error: $e', Colors.red);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant GraphicLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewOtherGraphics != widget.viewOtherGraphics) {
      _isLoading = true;
      _fetchChartData(); // Actualiza los datos cuando cambia el estado
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Indicador de carga
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: _dataPoints,
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withAlpha((0.3 * 255).toInt()))
                    .toList(),
              ),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 42,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                
                  axisSide: meta.axisSide,
                  child: Text(
                    _xLabels[value.toInt()] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize(context, 14),
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: _dataPoints.isNotEmpty ? _dataPoints.last.x : 0,
        // Ajusta el rango según los datos
        minY: 0,
        maxY: _dataPoints.isNotEmpty
            ? _dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)
            : 0, // Ajusta el rango según los datos
      ),
    );
  }
}
