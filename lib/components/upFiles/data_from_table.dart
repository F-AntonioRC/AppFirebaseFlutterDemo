import 'package:flutter/material.dart';

List<DataColumn> createColumns() {
  return [
    const DataColumn(label: Text('CUPO')),
    const DataColumn(label: Text('Nombre')),
    const DataColumn(label: Text('Area')),
    const DataColumn(label: Text('Puesto')),
    const DataColumn(label: Text('Sare')),
    const DataColumn(label: Text('Ore')),
  ];
}

List<DataRow> createRows() {
  return [
    const DataRow(cells: [
      DataCell(Text('200023')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('Recursos humanos')),
      DataCell(Text('Analista administrativo per..')),
      DataCell(Text('')),
      DataCell(Text('Administrativo')),
    ]),
    const DataRow(cells: [
      DataCell(Text('299956')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('Juridico')),
      DataCell(Text('Apoyo juridico')),
      DataCell(Text('2001')),
      DataCell(Text('')),
    ]),
  ];
}