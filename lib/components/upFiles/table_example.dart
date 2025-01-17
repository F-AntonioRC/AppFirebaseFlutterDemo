import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/upFiles/data_from_table.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

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
      headingRowColor: WidgetStateProperty.resolveWith((states) => greenColor),
    );
  }
}
