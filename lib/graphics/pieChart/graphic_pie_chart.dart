import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../indicator.dart';
import '../model_chart.dart';

  /// El Widget a continuacion muestra un gráfico de pastel (Pie Chart) basado en datos asíncronos.
  ///
  /// Recibe un título y una función que retorna un [Future] con una lista de [ChartData]
  /// que se utilizarán para generar el gráfico.

class GraphicPieChart extends StatefulWidget {
  final String title; // Título que se mostrará sobre el gráfico.
  final Future<List<ChartData>> graphicFunction; // Función que retorna un [Future] con la lista de datos para el gráfico.

  const GraphicPieChart({super.key, required this.graphicFunction, required this.title});

  @override
  State<GraphicPieChart> createState() => _GraphicPieChartState();
}

/// Estado asociado a [GraphicPieChart] que gestiona la carga de datos y la interaccion
/// con el gráfico.
class _GraphicPieChartState extends State<GraphicPieChart> {
  late Future<List<ChartData>> _futureChartData; // Futuro que almacena la lista de [ChartData] a mostrar en el gráfico.
  int touchedIndex = -1; // Índice de la sección del gráfico que se encuentra tocada (seleccionada).

  @override
  void initState() {
    super.initState();
    // Inicializa el futuro con la función proporcionada.
    _futureChartData = widget.graphicFunction;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ChartData>>(
      // Muestra un indicador de carga mientras se obtienen los datos.
      future: _futureChartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          // Muestra un mensaje de error en caso de que ocurra alguno.
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          // Cuando hay datos disponibles, renderiza el gráfico y sus elementos asociados.
        } else if (snapshot.hasData) {
          final chartData = snapshot.data!;
          return BodyWidgets(body:
          Column(
            children: [
              // Título del gráfico.
              Text(widget.title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveFontSize(context, 18)
              ),),
              const SizedBox(height: 15.0,),
              // Fila de indicadores que muestran la leyenda del gráfico.
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
                        : lightBackground,
                  );
                }).toList(),
              ),
              // Espacio que contiene el gráfico de pastel.
              Expanded(
                child: PieChart(
                  PieChartData(
                    // Configuración de la interacción táctil en el gráfico.
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          // Si no se detecta interacción o la sección tocada es nula, se resetea.
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          // Actualiza el índice de la sección tocada.
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    // Define el ángulo de inicio del gráfico.
                    startDegreeOffset: 180,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 1,
                    centerSpaceRadius: 0,
                    // Genera las secciones del gráfico a partir de los datos.
                    sections: _generateSections(chartData),
                  ),
                ),
              ),
            ],
          ));
        } else {
          // En caso de que no haya datos disponibles, se muestra un mensaje informativo.
          return const Center(child: Text('No hay datos disponibles'));
        }
      },
    );
  }

  /// La funcion `_generateSections` genera la lista de secciones para el gráfico de pastel a
  /// partir de la lista [data].
  ///
  /// Cada sección se configura en función de su valor, posición y si se encuentra seleccionada
  /// (tocada). Además, se calcula el porcentaje que representa cada valor con respecto al total.

  List<PieChartSectionData> _generateSections(List<ChartData> data) {
    // Calcula el total sumando los valores de cada elemento.
    final total = data.fold<int>(0, (add, item) => add + item.valor);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final chartData = entry.value;
      final isTouched = index == touchedIndex;
      // Calcula el porcentaje del valor actual.
      final double percentage = (chartData.valor / total) * 100;

      return PieChartSectionData(

        color: _getColor(index),
        value: chartData.valor.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        // Ajusta el radio de la sección según si está seleccionada.
        radius: isTouched ? 120 : 100,
        titlePositionPercentageOffset: 0.55,
        // Configura el borde de la sección.
        borderSide: isTouched
            ? const BorderSide(color: Colors.white, width: 6)
            : BorderSide(color: Colors.white.withAlpha((0.3 * 255).toInt())),
      );
    }).toList();
  }

  /// Retorna un color para la sección del gráfico en función del índice.
  ///
  /// Se utiliza una lista de colores predefinidos, retornando el color correspondiente
  /// al índice, haciendo uso del operador módulo para ciclos.

  Color _getColor(int index) {
    // Devuelve colores predefinidos o generados dinámicamente
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.yellow, Colors.purple];
    return colors[index % colors.length];
  }
}
