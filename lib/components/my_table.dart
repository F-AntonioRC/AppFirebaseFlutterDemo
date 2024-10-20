import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class MyTable extends StatelessWidget {
  final List<String> headers; // Caberas de la tabla
  final List<String> fieldKeys; //Atributos que se muestran
  final List<Map<String, dynamic>> data; // Datos almacenados
  final Function(String id) onEdit;  // Función para editar
  final Function(String id) onDelete;  // Función para eliminar

  const MyTable({
    super.key,
    required this.headers,
    required this.data,
    required this.fieldKeys,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          ...headers.map((header) {
            return DataColumn(
              label: Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          const DataColumn(  // Columna para las acciones
            label: Text(
              'Acciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: data.map((rowData) {
          return DataRow(
            cells: [
              ...fieldKeys.map((key) {
                return DataCell(Text(rowData[key]?.toString() ?? ''));
              }).toList(),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded),
                      color: greenColor,
                      onPressed: () {
                        onEdit(rowData['id']);  // Llamar a la función de editar
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: () {
                        onDelete(rowData['id']);  // Llamar a la función de eliminar
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
