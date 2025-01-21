import 'package:flutter/material.dart';

List<DataColumn> createColumns() {
  return [
    const DataColumn(label: Text('CUPO')),
    const DataColumn(label: Text('Estado')),
    const DataColumn(label: Text('Nombre')),
    const DataColumn(label: Text('Correo')),
    const DataColumn(label: Text('Area')),
    const DataColumn(label: Text('Puesto')),
    const DataColumn(label: Text('Sare')),
  ];
}

List<DataRow> createRows() {
  return [
    const DataRow(cells: [
      DataCell(Text('200023')),
      DataCell(Text('Activo')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('Cupo.Nombre@becasbenitojuarez.gob.mx')),
      DataCell(Text('RECURSOS HUMANOS')),
      DataCell(Text('AUXILIAR DE ARCHIVO')),
      DataCell(Text('ORE')),
    ]),
    const DataRow(cells: [
      DataCell(Text('299956')),
      DataCell(Text('Inactivo')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('Cupo.Nombre@becasbenitojuarez.gob.mx')),
      DataCell(Text('JURIDICO')),
      DataCell(Text('APOYO JURIDICO')),
      DataCell(Text('2001')),
    ]),
  ];
}