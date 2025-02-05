//La clase `ChartData``se utiliza para establecer los valores que se utilizaran en las
//graficas

class ChartData {
  final String campo; // Define el campo para mostrar en la grafica
  final int valor; // Define el valor para renderizar los datos en la grafica

  /// Constructor de la clase que inicializa [campo] y [valor].
  ChartData(this.campo, this.valor);
}