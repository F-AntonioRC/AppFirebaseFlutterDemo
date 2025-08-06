import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class PaginatedTableNormal extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final bool isLoading;

  const PaginatedTableNormal(
      {super.key,
      required this.columns,
      required this.rows,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: PaginatedDataTable(
              headingRowColor: WidgetStateProperty.all(greenColorLight),
              columns: columns
                  .map((col) => DataColumn(
                          label: Text(
                        col,
                        style: TextStyle(
                            fontSize: responsiveFontSize(context, 18),
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )))
                  .toList(),
              source: _TableData(rows),
              rowsPerPage: 5, // Número de filas por página
            ),
          );
  }
}

class _TableData extends DataTableSource {
  final List<Map<String, dynamic>> rows;

  _TableData(this.rows);

  @override
  DataRow getRow(int index) {
    if (index >= rows.length) return const DataRow(cells: []);
    final row = rows[index];

    return DataRow(
    cells: row.values.map((value) {
      if (value is Widget) {
        return DataCell(value);
      } else {
        return DataCell(Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      }
    }).toList(),
  );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}
