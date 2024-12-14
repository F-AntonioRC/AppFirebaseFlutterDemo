import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class TableComponentNormal extends StatelessWidget {
  const TableComponentNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label:
          Expanded(child: Text("Nombre del curso", style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 20)),))),
          DataColumn(label:
          Expanded(child: Text("Fecha de envio de constancia", style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 20)),))),
          DataColumn(label:
          Expanded(child: Text("Estado", style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 20)),)))
        ], rows: [
      DataRow(cells: [
        DataCell(Text("Cuidado del agua", style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 18)))),
        DataCell(Text("20/12/24", style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 18)))),
        DataCell(Row(children: [
          Text("Enviado", style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: responsiveFontSize(context, 18))),
          const SizedBox(width: 10.0),
          const Icon(Icons.check_circle, color: greenColor,)
        ],)),
      ])
    ]);
  }
}
