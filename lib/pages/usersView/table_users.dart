import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/components/table/MyPaginatedTable.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/usersView/dialog_delete_users.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/usersService/database_methods_users.dart';

class TableUsers extends StatelessWidget {
  final List<Map<String, dynamic>>
      filteredData; //Variable para guardar datos filtrados
  final DatabaseMethodsUsers
      databaseMethodsUsers; //Invocación de los metodos en la clase methodsDetailCourses
  final bool
      isActive; //Variable para cambiar el valor del tooltip en el componente MyPaginatedTable
  final Function() refreshTable; //Función para actualizar la UI

  const TableUsers(
      {super.key,
      required this.filteredData,
      required this.databaseMethodsUsers,
      required this.isActive,
      required this.refreshTable});

  @override
  Widget build(BuildContext context) {
    //Nombre del campo Id en la coleccion correspondiente
    const String idKey = "uid";
    return Consumer<EditProvider>(builder: (context, editProvider, child) {
      return FutureBuilder(
        future: databaseMethodsUsers.getDataUsers(),
        builder: (context, snapshot) {
          //En esta parte del código se realizan validaciones para poder mostrar diferentes widgets
          //dependiendo del estado de la carga de datos para mostrar en el widget personalizado
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron Usuarios.'));
          } else {
            final data = filteredData.isEmpty ? snapshot.data! : filteredData;
            // El widget `MyPaginatedTable` en el fragmento de código es un widget personalizado
            // que muestra una tabla paginada con encabezados y campos de datos específicos.
            return MyPaginatedTable(
              //Nombre de las cabeceras que tendra la tabla
              headers: const ["Nombre", "CUPO",  "Clave Usuario", "Existe en Empleados", "Tiene cursos"],
              //Datos extraidos de la base de datos, junto con el nombre del campo para mostrar su valor
              //en las filas del componente MyPaginatedTable
              data: data,
              fieldKeys: const ["empleadoNombre", "CUPO", "uid", "estaDadoDeAlta", "hasCompletedCourse"],
              // La función `onEdit` en el código es una función de devolución de llamada
              //que se activa cuando un usuario desea editar una fila específica en la tabla de cursos asignados.
              //Usando el valor idKey para realizar la edición.
              onEdit: (String id) {
                showCustomSnackBar(context, "La edición/asignación del CUPO es en el Módulo Empleados", greenColorLight);
              },
              // La función `onDelete` en el código es una función de devolución de llamada
              //que se activa cuando un usuario desea eliminar una fila específica en la tabla de cursos asignados.
              onDelete: (String id)  {
                  final selectedRow = data.firstWhere((row) => row[idKey] == id);
                  final uid = selectedRow["uid"];
                  final cupo = selectedRow["CUPO"].toString();
                  showDialog(context: context, builder: (BuildContext context) {
                    return DialogDeleteUsers(
                      uidChange: uid, 
                      cupo: cupo, 
                      refreshTable: refreshTable);
                  });
              },
              idKey: idKey,
              onActive: true,
                customCellsIcon: {
                "hasCompletedCourse": (value) => Icon(
                value == true ? Icons.check_circle : Icons.cancel,
                color: value == true ? Colors.green : Colors.red,
                ),
                "estaDadoDeAlta": (value) => Icon(
                value == true ? Icons.check_circle : Icons.cancel,
                color: value == true ? Colors.green : Colors.red,
                ),
  },
            );
          }
        },
      );
    });
  }
}
