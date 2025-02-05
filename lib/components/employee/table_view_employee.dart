import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/table/MyPaginatedTable.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/database_methods_employee.dart';
import '../../dataConst/constand.dart';
import '../formPatrts/custom_snackbar.dart';
import 'assignCupoDialog.dart';

/// La clase `TableViewEmployee` en Flutter es un widget sin estado que muestra una tabla de empleados con
/// opciones para editar, eliminar y activar/desactivar empleados según ciertas condiciones.
class TableViewEmployee extends StatelessWidget {
  final bool viewInactivos; //Estado para mostrar los datos de los cursos Activos/Inactivos
  final List<Map<String, dynamic>> filteredData; //Variable para guardar datos filtrados
  final DatabaseMethodsEmployee databaseMethods; //Invocación de los metodos en la clase databaseMethods
  final bool isActive; //Variable para cambiar el valor del tooltip en el componente MyPaginatedTable
  final Function() refreshTable; //Función para actualizar la UI

  const TableViewEmployee(
      {super.key,
      required this.viewInactivos,
      required this.filteredData,
      required this.databaseMethods,
      required this.isActive,
      required this.refreshTable});

  @override
  Widget build(BuildContext context) {
    //Nombre del campo Id en la coleccion correspondiente
    const String idKey = "IdEmpleado";

/// Esta parte del código utiliza un widget `Consumer` del paquete `provider` en Flutter. El
/// widget `Consumer` se utiliza para escuchar los cambios en un proveedor específico (`EditProvider` 
/// en este caso) y reconstruir su widget secundario siempre que el proveedor notifique a los oyentes 
/// sobre los cambios.
    return Consumer<EditProvider>
      (builder: (context, editProvider, child) {
        return FutureBuilder(
          //Mostrar los empleados Activos/Inactivos dependiendo del valor de ´viewInactivos´
          future: viewInactivos
              ? databaseMethods.getDataEmployee(false)
              : databaseMethods.getDataEmployee(true),
          builder: (context, snapshot) {
          //En esta parte del código se realizan validaciones para poder mostrar diferentes widgets 
          //dependiendo del estado de la carga de datos para mostrar en el widget personalizado
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if ((!snapshot.hasData || snapshot.data!.isEmpty) &&
                filteredData.isEmpty) {
              return const Center(child: Text('No se encontraron empleados.'));
            } else {
              final data = filteredData.isEmpty ? snapshot.data! : filteredData;
            // El widget `MyPaginatedTable` en el fragmento de código es un widget personalizado
            // que muestra una tabla paginada con encabezados y campos de datos específicos.
              return MyPaginatedTable(
                //Nombre de las cabeceras que tendra la tabla
                headers: const [
                  "Nombre Completo",
                  "CUPO",
                  "Estado",
                  "Area",
                  "Ore",
                  "Sare"
                ],
                //Datos extraidos de la base de datos, junto con el nombre del campo para mostrar su valor
                //en las filas del componente MyPaginatedTable
                data: data,
                fieldKeys: const [
                  "Nombre",
                  "CUPO",
                  "Estado",
                  "Area",
                  "Ore",
                  "Sare"
                ],
              // La función `onEdit` en el código es una función de devolución de llamada 
              //que se activa cuando un usuario desea editar una fila específica en la tabla de empleados.
              //Usando el valor idKey para realizar la edición.
                onEdit: (String id) {
                  final selectedRow = data.firstWhere((row) => row[idKey] == id);

                  Provider.of<EditProvider>(context, listen: false)
                      .setData(selectedRow);
                },
                // La función `onDelete` en el código es una función de devolución de llamada 
                //que se activa cuando un usuario desea eliminar una fila específica en la tabla de empleados.
                onDelete: (String id) async {
                  try {
                    await databaseMethods.deleteEmployeeDetail(id);
                    refreshTable();
                    if (context.mounted) {
                      showCustomSnackBar(
                          context, "Empleado eliminado Correctamente", greenColor);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showCustomSnackBar(context, "Error: $e", Colors.red);
                    }
                  }
                },                
                // La función `onAssign` en el código es una función de devolución de llamada 
                //que se activa cuando un usuario desea asignar un valor a la fila específica en la 
                //tabla de empleados.
                // Detalles del cuadro de diálogo:
                // - `dataChange`: Recibe el valor de `name`, que corresponde al nombre asociado con la fila seleccionada.
                // - `idChange`: Recibe el valor de `idAdd`, que corresponde al identificador de la fila seleccionada.
                // - `refreshTable`: Se pasa como argumento para permitir que el diálogo pueda desencadenar 
                // la actualización de la tabla después de realizar alguna acción.
                onAssign: (String id) {
                  final selectedRow = data.firstWhere((row) => row[idKey] == id);
                  final name = selectedRow["Nombre"];
                  final idAdd = selectedRow[idKey];
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AssignCupoDialog(
                        dataChange: name,
                        idChange: idAdd,
                        refreshTable: refreshTable,
                      );
                    },
                  );
                },
                //Valor para mostrar en el icono de la función onAssign
                tooltipAssign: "Asignar CUPO",
                idKey: idKey,
                onActive: isActive,
              // La `activateFunction` es una función de devolución de llamada que se activa cuando un
              // usuario desea activar (restaurar) un empleado específico en la tabla de empleado.
                activateFunction: (String id) async {
                  try {
                    await databaseMethods.activateEmployeeDetail(id);
                    refreshTable();
                    if (context.mounted) {
                      showCustomSnackBar(
                          context, "Empleado restaurado Correctamente", greenColor);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showCustomSnackBar(context, "Error: $e", Colors.red);
                    }
                  }
                },
                //Valores del icono para la funcion onAssign
                iconAssign: const Icon(
                  Icons.engineering,
                  color: Colors.blue,
                ),
              );
            }
          },
        );
    });
  }
}