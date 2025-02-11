import 'package:flutter/material.dart';

class TableExampleData {
/// Crea una lista de columnas para el Widget `TableExample`.
///
/// Cada `DataColumn` representa un encabezado en la tabla, valores importantes para poder
/// subir nuevos registros a la base de datos.
/// Es importante destacar que los datos no deben tener acento salvo en el campo Nombre
/// ya que conforme a la estructura de la base de datos, los valores no se registran correctamente

static final List<DataColumn> columns =  [
    const DataColumn(label: Text('CUPO')),
    // Número de identificación del empleado
    const DataColumn(label: Text('Estado')),
    // Estado actual del empleado (Activo/Inactivo)
    const DataColumn(label: Text('Nombre')),
    // Nombre completo del empleado
    const DataColumn(label: Text('Correo')),
    // Correo electrónico institucional del empleado
    const DataColumn(label: Text('Area')),
    // Área de trabajo del empleado
    const DataColumn(label: Text('Puesto')),
    // Puesto o cargo del empleado
    const DataColumn(label: Text('Sare')),
    // Código de identificación de la unidad en la que este el empleado
  ];

/// Crea una lista de filas con datos para el Widget `TableExample`.
///
/// Cada `DataRow` representa un empleado con su respectiva información.
 static final List<DataRow> rows = [
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