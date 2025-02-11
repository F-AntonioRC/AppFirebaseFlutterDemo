import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/table/MyPaginatedTable.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/coursesService/database_courses.dart';

/// La clase `TableViewCourses` en Flutter es un widget sin estado que muestra una tabla de cursos con
/// opciones para editar, eliminar y activar/desactivar cursos según ciertas condiciones.
class TableViewCourses extends StatelessWidget {
  final bool viewInactivos; //Estado para mostrar los datos de los cursos Activos/Inactivos
  final List<Map<String, dynamic>> filteredData; //Variable para guardar datos filtrados
  final MethodsCourses methodsCourses; //Invocación de los metodos en la clase MethodsCourses
  final bool isActive; //Variable para cambiar el valor del tooltip en el componente MyPaginatedTable
  final Function() refreshTable; //Función para actualizar la UI

  const TableViewCourses({
    super.key,
    required this.viewInactivos,
    required this.filteredData,
    required this.methodsCourses,
    required this.isActive,
    required this.refreshTable,
  });

  @override
  Widget build(BuildContext context) {
    //Nombre del campo Id en la coleccion correspondiente
    const String idKey = "IdCurso";

/// Esta parte del código utiliza un widget `Consumer` del paquete `provider` en Flutter. El
/// widget `Consumer` se utiliza para escuchar los cambios en un proveedor específico (`EditProvider` 
/// en este caso) y reconstruir su widget secundario siempre que el proveedor notifique a los oyentes 
/// sobre los cambios.
    return Consumer<EditProvider>(builder: (context, editProvider, child) {
      return FutureBuilder(
        //Mostrar los cursos Activos/Inactivos dependiendo del valor de ´viewInactivos´
        future: viewInactivos
            ? methodsCourses.getDataCourses(false)
            : methodsCourses.getDataCourses(true),
        builder: (context, snapshot) {
          //En esta parte del código se realizan validaciones para poder mostrar diferentes widgets 
          //dependiendo del estado de la carga de datos para mostrar en el widget personalizado
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron cursos.'));
          } else {
            final data = filteredData.isEmpty ? snapshot.data! : filteredData;
          // El widget `MyPaginatedTable` en el fragmento de código es un widget personalizado
          // que muestra una tabla paginada con encabezados y campos de datos específicos.
            return 
            MyPaginatedTable(
              //Nombre de las cabeceras que tendra la tabla
              headers: const [
                "Nombre",
                "Dependencia",
                "Trimestre",
                "Inicio",
                "Registro",
                "Constancia"
              ],
              //Datos extraidos de la base de datos, junto con el nombre del campo para mostrar su valor
              //en las filas del componente MyPaginatedTable
              data: data,
              fieldKeys: const [
                "NombreCurso",
                "Dependencia",
                "Trimestre",
                "FechaInicioCurso",
                "FechaRegistro",
                "FechaEnvioConstancia"
              ],
              // La función `onEdit` en el fragmento de código es una función de devolución de llamada 
              //que se activa cuando un usuario desea editar una fila específica en la tabla de cursos.
              //Usando el valor idKey para realizar la edición.
              onEdit: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id);

                Provider.of<EditProvider>(context, listen: false).setData(selectedRow);
              },
              // La función `onDelete` en el código es una función de devolución de llamada 
              //que se activa cuando un usuario desea eliminar una fila específica en la tabla de cursos
              onDelete: (String id) async {
                try {
                  await methodsCourses.deleteCoursesDetail(id);
                  refreshTable();
                  if(context.mounted) {
                    showCustomSnackBar(context, "Curso eliminado correctamente", greenColorLight);
                  }
                } catch (e, stackTrace) {
                  if(context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                  await Sentry.captureException(
                    e,
                    stackTrace: stackTrace,
                    withScope: (scope) {
                      scope.setTag('MyPaginatedTable_error_deleteCoursesDetail', id);
                    }
                    );
                }
              },
              //Envio de la clave del campo para realizar acciones en el componente MyPaginatedTable
              idKey: idKey,
              onActive: isActive,
              // La `activateFunction` es una función de devolución de llamada que se activa cuando un
              // usuario desea activar (restaurar) un curso específico en la tabla de cursos.
              activateFunction: (String id) async {
                try {
                  await methodsCourses.activateCoursesDetail(id);
                  refreshTable();
                  if(context.mounted) {
                    showCustomSnackBar(context, "Curso restaurado correctamente", greenColorLight);
                  }
                } catch (e, stackTrace) {
                  if(context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                    await Sentry.captureException(
                    e,
                    stackTrace: stackTrace,
                    withScope: (scope) {
                      scope.setTag('MyPaginatedTable_error_deleteCoursesDetail', id);
                    }
                    );
                }
              },
            );
          }
        },
      );
    });
  }
}