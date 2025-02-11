import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

  /// Este widget renderiza un [LineChart] de ejemplo dentro de una tarjeta y permite alternar
  /// entre la visualización de datos "normales" y un promedio (avg) mediante un botón.
class LineChartSample extends StatefulWidget {
  const LineChartSample({super.key});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  // Colores que se usan para generar un degradado en la línea del gráfico.
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  // Bandera para alternar entre la visualización de datos principales y el promedio.
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          // Área que contiene el gráfico de líneas con un aspect ratio personalizado.
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                // Se muestra el gráfico principal o el promedio según el estado.
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
          // Botón para alternar la visualización entre los datos principales y el promedio.
          SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? lightBackground: darkBackground,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  /// Widget que construye las etiquetas del eje X (inferior) del gráfico.
  ///
  /// Dependiendo del valor, se muestran las abreviaturas de los meses.

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    // Valores para mostrar en el eje X
    switch (value.toInt()) {
      case 2:
        text = const Text('ENE', style: style);
        break;
      case 5:
        text = const Text('FEB', style: style);
        break;
      case 8:
        text = const Text('MAR', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide ,
      child: text,
    );
  }

  /// Widget que construye las etiquetas del eje Y (izquierdo) del gráfico.
  ///
  /// Se asignan etiquetas específicas a ciertos valores del eje Y.

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    // Valores para mostrar en el eje Y
    switch (value.toInt()) {
      case 1:
        text = '5';
        break;
      case 3:
        text = '15';
        break;
      case 5:
        text = '20';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  /// Configura y retorna los datos principales para el gráfico de líneas.
  ///
  /// Se configuran los ejes, la cuadrícula, los títulos y la apariencia de la línea,
  /// incluyendo el degradado, el ancho de la línea y la zona sombreada debajo de la línea.

  LineChartData mainData() {
    return LineChartData(
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
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      // Rango del eje X e Y
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      // Configuración de la línea del gráfico
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withAlpha((0.3 * 255).toInt()))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Configura y retorna los datos para mostrar el promedio en el gráfico de líneas.
  ///
  /// En este modo, la línea se representa de forma uniforme (sin fluctuaciones) para
  /// indicar un valor promedio constante. También se configura la cuadrícula y los títulos.

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta),
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
            reservedSize: 42,
            interval: 1,
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
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withAlpha((0.1 * 255).toInt()),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withAlpha((0.1 * 255).toInt()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}