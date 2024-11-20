import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MyTable extends StatelessWidget {
  final List<String> headers; // Caberas de la tabla
  final List<String> fieldKeys; //Atributos que se muestran
  final List<Map<String, dynamic>> data; // Datos almacenados
  final String idKey; //Valor del id
  final Function(String id) onEdit;  // Función para editar
  final Function(String id) onDelete;  // Función para eliminar
  final bool onActive; //Estado del boton dinamico
  final Function(String id) activateFunction;
  final Function(String id)? onAssign; //Función opcional


  const MyTable({
    super.key,
    required this.headers,
    required this.data,
    required this.fieldKeys,
    required this.onEdit,
    required this.onDelete,
    this.onAssign,
    required this.idKey,
    required this.onActive,
    required this.activateFunction
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
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
                  return DataCell(
                      Text(rowData[key]?.toString() ?? '',
                        style: TextStyle(fontSize: responsiveFontSize(context, 12)),)  );
                }),
                DataCell(
                  Row(
                    children: [
                      Ink(
                          decoration: const ShapeDecoration(shape: CircleBorder(  ), color: ligth),
                        child: IconButton(
                          tooltip: "Editar",
                          icon: const Icon(Icons.edit),
                          color: greenColor,
                          onPressed: () {
                            onEdit(rowData[idKey].toString());  // Llamar a la función de editar
                          },
                        ),
                      ),
                      //Boton dinamico
                      Ink(
                        decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
                        child: IconButton(
                            icon: Icon(onActive
                            ? Icons.delete_forever_sharp
                            : Icons.power_settings_new),
                            tooltip: onActive ? "Eliminar" : "Activar",
                            color: onActive ? Colors.red : Colors.red,
                            onPressed: () {
                            if(onActive){
                              try{
                                onDelete(rowData[idKey].toString());
                              } catch (e) {
                                showCustomSnackBar(context, "Error: $e", Colors.red);
                              }
                            } else {
                              activateFunction(rowData[idKey].toString());
                            }

                            }
                        )
                      ),
                      if( onAssign !=null )
                        Ink(
                          decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
                          child: IconButton(
                              tooltip: "Asignar CUPO",
                              onPressed: () {
                            onAssign!(rowData[idKey].toString());
                          }, icon: const Icon(Icons.manage_accounts, color: Colors.blue,)),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}