import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/upFiles/data_from_table.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

/// Un widget que muestra una tabla (`DataTable`) con datos de ejemplo para poder realizar la escritura
/// de nuevos registros en la base de datos.
class TableExample extends StatelessWidget {
  const TableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: createColumns(), rows: createRows(),
        dividerThickness: 2,
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
      //Color de los headers en la tabla
      headingRowColor: WidgetStateProperty.resolveWith((states) => greenColor),
    );
  }
}
