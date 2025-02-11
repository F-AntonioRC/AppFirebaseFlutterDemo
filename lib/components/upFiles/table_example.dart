import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

/// La clase `TableExample` es un widget reutilizable que muestra una tabla (`DataTable`) con datos
/// de ejemplo para poder mostrar en la UI.
class TableExample extends StatelessWidget {
  // Recibe los datos a mostrar para las columnas y filas.
  final List<DataColumn> dataColumn;
  final List<DataRow> dataRow;

  const TableExample({super.key, required this.dataColumn, required this.dataRow});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: dataColumn, rows: dataRow,
        dividerThickness: 2,
        headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        //Color de los headers en la tabla
        headingRowColor: WidgetStateProperty.resolveWith((states) => greenColorLight),
      ),
    );
  }
}
