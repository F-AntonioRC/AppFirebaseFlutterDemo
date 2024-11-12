import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MyTable extends StatelessWidget {
  final List<String> headers; // Caberas de la tabla
  final List<String> fieldKeys; //Atributos que se muestran
  final List<Map<String, dynamic>> data; // Datos almacenados
  final String idKey; //Valor del id
  final Function(String id) onEdit;  // Función para editar
  final Function(String id) onDelete;  // Función para eliminar
  final Function(String id)? onAssign; //Función no necesaria


  const MyTable({
    super.key,
    required this.headers,
    required this.data,
    required this.fieldKeys,
    required this.onEdit,
    required this.onDelete,
    this.onAssign, required this.idKey
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
                style: TextStyle(fontSize: responsiveFontSize(context, 15), fontWeight: FontWeight.bold),
              ),
            );
          }),
          DataColumn(  // Columna para las acciones
            label: Text(
              'Acciones',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 15),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: data.map((rowData) {
          return DataRow(
            cells: [
              ...fieldKeys.map((key) {
                return DataCell(Text(rowData[key]?.toString() ?? '', style: TextStyle(fontSize: responsiveFontSize(context, 12)), textAlign: TextAlign.center,)  );
              }),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: greenColor,
                      onPressed: () {
                        onEdit(idKey);  // Llamar a la función de editar
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: () {
                        onDelete(idKey);  // Llamar a la función de eliminar
                      },
                    ),
                    if( onAssign !=null )
                      IconButton(onPressed: () {
                        onAssign!(idKey);
                      }, icon: const Icon(Icons.manage_accounts, color: Colors.blue,))
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
