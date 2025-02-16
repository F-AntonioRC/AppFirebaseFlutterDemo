import 'package:flutter/material.dart';

class TableExampleData {
/// Crea una lista de columnas para el Widget `TableExample`.
///
/// Cada `DataColumn` representa un encabezado en la tabla, valores importantes para poder
/// subir nuevos registros a la base de datos.
/// Es importante destacar que los datos no deben tener acento salvo en el campo Nombre
/// ya que conforme a la estructura de la base de datos, los valores no se registran correctamente

static final List<DataColumn> columns =  [
    // Número de identificación del empleado
    const DataColumn(label: Text('CUPO')),
    // Estado actual del empleado (Activo/Inactivo)
    const DataColumn(label: Text('Estado')),
    // Nombre completo del empleado
    const DataColumn(label: Text('Nombre')),
    // Puesto de trabajo del empleado
    const DataColumn(label: Text('Puesto')),
    // Correo institucional del empleado
    const DataColumn(label: Text('Correo')),
    // Sare del empleado
    const DataColumn(label: Text('Sare')),
    // Sexo del empleado
    const DataColumn(label: Text('Sexo')),
    // Area del empleado
    const DataColumn(label: Text('Area')),
  ];

/// Crea una lista de filas con datos para el Widget `TableExample`.
///
/// Cada `DataRow` representa un empleado con su respectiva información.
 static final List<DataRow> rows = [
    const DataRow(cells: [
      DataCell(Text('200023')),
      DataCell(Text('Activo')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('AUXILIAR DE ARCHIVO')),
      DataCell(Text('Cupo.Nombre@becasbenitojuarez.gob.mx')),
      DataCell(Text('ORE')),
      DataCell(Text('M')),
      DataCell(Text('RECURSOS HUMANOS')),
    ]),
    const DataRow(cells: [
      DataCell(Text('299956')),
      DataCell(Text('Inactivo')),
      DataCell(Text('Nombre Completo')),
      DataCell(Text('APOYO JURIDICO')),
      DataCell(Text('Cupo.Nombre@becasbenitojuarez.gob.mx')),
      DataCell(Text('2001')),
      DataCell(Text('H')),
      DataCell(Text('JURIDICO')),
    ]),
  ];
}