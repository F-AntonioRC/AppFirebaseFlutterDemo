import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import '../../util/responsive.dart';
import '../model_chart.dart';
import 'line_chart_service.dart';

  /// El Widget `GraphicLineChart` muestra un gráfico de líneas basado en datos asíncronos.
  ///
  /// Permite alternar la vista entre diferentes conjuntos de datos a través del parámetro
  /// [viewOtherGraphics]. Dependiendo de este parámetro, se solicitarán datos distintos para
  /// renderizar el gráfico.

class GraphicLineChart extends StatefulWidget {
  final bool viewOtherGraphics; // Parámetro que indica si se debe mostrar otro conjunto de gráficos.

  // Constructor del widget.
  const GraphicLineChart({super.key, required this.viewOtherGraphics});

  @override
  State<GraphicLineChart> createState() => _GraphicLineChartState();
}

  /// Estado asociado a [GraphicLineChart] que se encarga de la lógica de carga y renderizado
  /// del gráfico de líneas.
class _GraphicLineChartState extends State<GraphicLineChart> {
  // Colores usados para el degradado en el gráfico.
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  // Servicio para obtener los datos que se mostrarán en el gráfico.
  final LineChartService _chartLineService = LineChartService();
  List<FlSpot> _dataPoints = []; // Lista de puntos (spots) que se utilizarán para renderizar el gráfico.
  Map<int, String> _xLabels = {}; // Mapa que relaciona índices numéricos con etiquetas para el eje X.
  bool _isLoading = true; // Indicador de carga que muestra si los datos aún se están obteniendo.

  // Funcion para inicializar la carga de datos
  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  /// La funcion `_fetchChartData` obtiene y procesa los datos para el gráfico de líneas de forma asíncrona.
  ///
  /// Se determina el campo de datos a solicitar en función del parámetro [viewOtherGraphics].
  /// Luego se transforma la información recibida en una lista de puntos ([FlSpot]) y en un
  /// mapa de etiquetas para el eje X.
  ///
  /// En caso de error, se muestra un mensaje de error en pantalla.
  Future<void> _fetchChartData() async {
    try {
      // Se obtienen los datos desde el servicio.
      List<ChartData> chartData =
      // Se selecciona el campo de datos a usar según el parámetro viewOtherGraphics.
      widget.viewOtherGraphics
          ? await _chartLineService.getArrayDataByDate('CursosCompletados', 'FechaCursoCompletado')
        : await _chartLineService.getDataBySelect('Empleados', 'Sare');

      // Se preparan los puntos del gráfico y las etiquetas para el eje X.
      List<FlSpot> dataPoints = [];
      Map<int, String> xLabels = {}; // Mapa para las etiquetas del eje X

      for (int i = 0; i < chartData.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), chartData[i].valor.toDouble()));
        xLabels[i] =
            chartData[i].campo; // Se asigna la etiqueta correspondiente
      }

      // Actualiza el estado con los nuevos datos y desactiva el indicador de carga.
      setState(() {
        _dataPoints = dataPoints;
        _xLabels = xLabels;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      // En caso de error, muestra un SnackBar personalizado y actualiza el indicador de carga
      // ademas de enviar los errores a Sentry.
      if (mounted) {
        showCustomSnackBar(context, 'Error: $e', Colors.red);
      }
      Sentry.captureException(e, stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('Error_Widget_GraphicLineChart', e.toString());
      }
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant GraphicLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el parámetro viewOtherGraphics cambia, se recargan los datos.
    if (oldWidget.viewOtherGraphics != widget.viewOtherGraphics) {
      _isLoading = true;
      _fetchChartData(); // Actualiza los datos cuando cambia el estado
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si se están cargando los datos, muestra un indicador de carga.
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Indicador de carga
      );
    }

    // Cuando los datos están listos, renderiza el gráfico de líneas.
    return LineChart(
      LineChartData(
        // Configuración de la línea del gráfico.
        lineBarsData: [
          LineChartBarData(
            spots: _dataPoints, // Datos para mostrar en el eje y
            isCurved: true, // Valor que dibuja la línea de la grafica con bordes curvos
            gradient: LinearGradient(colors: gradientColors),  // Colores del grafico
            barWidth: 5, // Determina el grosor de la línea de dibujo.
            isStrokeCapRound: true, // Determina el estilo del límite de la línea.
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
        // Configuración de las líneas de la cuadrícula.
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
        // Configuración de los títulos y etiquetas en los ejes.
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              reservedSize: 42,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              // Función para obtener el widget que muestra la etiqueta en el eje X.
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
        // Configuración del borde del gráfico.
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        // Configuración del rango de los ejes X e Y según los datos.
        minX: 0,
        maxX: _dataPoints.isNotEmpty ? _dataPoints.last.x : 0,
        minY: 0,
        maxY: _dataPoints.isNotEmpty
            ? _dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)
            : 0,
      ),
    );
  }
}
