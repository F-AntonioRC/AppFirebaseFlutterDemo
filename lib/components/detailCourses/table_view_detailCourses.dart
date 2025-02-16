import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/table/MyPaginatedTable.dart';
import 'package:testwithfirebase/components/sendEmail/dialog_email.dart';
import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';
import '../../dataConst/constand.dart';
import '../../providers/edit_provider.dart';
import '../formPatrts/custom_snackbar.dart';

/// La clase `TableViewDetailCourses` en Flutter es un widget sin estado que muestra una tabla de cursos
/// asignados con opciones para editar, eliminar y activar/desactivar cursos según ciertas condiciones.
class TableViewDetailCourses extends StatelessWidget {
  final bool viewInactivos; //Estado para mostrar los datos de los cursos Activos/Inactivos
  final List<Map<String, dynamic>> filteredData; //Variable para guardar datos filtrados
  final MethodsDetailCourses methodsDetailCourses; //Invocación de los metodos en la clase methodsDetailCourses
  final bool isActive; //Variable para cambiar el valor del tooltip en el componente MyPaginatedTable
  final Function() refreshTable; //Función para actualizar la UI

  const TableViewDetailCourses({super.key,
    required this.viewInactivos,
    required this.filteredData,
    required this.methodsDetailCourses,
    required this.isActive,
    required this.refreshTable});

  @override
  Widget build(BuildContext context) {
    //Nombre del campo Id en la coleccion correspondiente
    const String idKey = "IdDetalleCurso";

/// Esta parte del código utiliza un widget `Consumer` del paquete `provider` en Flutter. El
/// widget `Consumer` se utiliza para escuchar los cambios en un proveedor específico (`EditProvider` 
/// en este caso) y reconstruir su widget secundario siempre que el proveedor notifique a los oyentes 
/// sobre los cambios.
    return Consumer<EditProvider>(builder:
    (context, editProvider, child) {
      return FutureBuilder(
        //Mostrar los cursos asignados Activos/Inactivos dependiendo del valor de ´viewInactivos´
        future: viewInactivos
            ? methodsDetailCourses.getDataDetailCourse(false)
            : methodsDetailCourses.getDataDetailCourse(true),
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
            return MyPaginatedTable(
              //Nombre de las cabeceras que tendra la tabla
              headers: const [
                "Nombre",
                "Ore",
                "Sare",
                "Estado",
                "Inicio curso",
                "Registro",
                "Envío Constancia",
              ],
                //Datos extraidos de la base de datos, junto con el nombre del campo para mostrar su valor
                //en las filas del componente MyPaginatedTable
              data: data,
              fieldKeys: const [
                "NombreCurso",
                "Ore",
                "sare",
                "Estado",
                "FechaInicioCurso",
                "FechaRegistro",
                "FechaEnvioConstancia",
              ],
              // La función `onEdit` en el código es una función de devolución de llamada 
              //que se activa cuando un usuario desea editar una fila específica en la tabla de cursos asignados.
              //Usando el valor idKey para realizar la edición.
              onEdit: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id);
                Provider.of<EditProvider>(context, listen: false)
                    .setData(selectedRow);
              },
              // La función `onDelete` en el código es una función de devolución de llamada 
              //que se activa cuando un usuario desea eliminar una fila específica en la tabla de cursos asignados.
              onDelete: (String id) async {
                try {
                  await methodsDetailCourses.deleteDetalleCursos(id);
                  refreshTable();
                  if (context.mounted) {
                    showCustomSnackBar(
                        context, "Curso eliminado correctamente", greenColorLight);
                  }
                } catch (e) {
                  if (context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              },
              // La función `onAssign` en el código es una función de devolución de llamada 
              //que se activa cuando un usuario desea enviar un correo con los datos de la fila 
              //específica en la tabla de empleados.
              // Detalles del cuadro de diálogo:
              // - `nameCourse`: Recibe el valor de `NombreCurso`, que corresponde al nombre del curso.
              // - `dateInit`: Recibe el valor de `FechaInicioCurso`, que corresponde a la fecha que inicia el curso.
              // - `dateRegister`: Recibe el valor de `FechaRegistro`, que corresponde a la fecha que inicia el curso.
              // - `dateSendDocument`: Recibe el valor de `dateSendDocument`, que corresponde a la fecha que se envia la constancia.
              // - `oreSelected`: Recibe el valor de `Ore`, que corresponde al Ore asigando del curso.
              // - `sareSelected`: Recibe el valor de `sare`, que corresponde al Sare asignado del curso.
              // - `idOreSelected`, ´idSareSelected´: Recibe el valor de los ´Id's´ correspondientes a los valores seleccionados.
              onAssign: (String id) {
                final selectedRow = data.firstWhere((row) => row[idKey] == id, orElse: () => {});
                if(selectedRow.isNotEmpty) {
                  final nameCourse = selectedRow['NombreCurso'] ?? '';
                  final dateInit = selectedRow['FechaInicioCurso'] ?? '';
                  final dateRegister = selectedRow['FechaRegistro'] ?? '';
                  final dateSendDocument = selectedRow['FechaEnvioConstancia'] ?? '';
                  final oreSelected = selectedRow['Ore'] ?? 'N/A';
                  final sareSelected = selectedRow['sare'] ?? 'N/A';
                  final idOreSelected = selectedRow['IdOre'] ?? 'N/A';
                  final idSareSelected = selectedRow['IdSare'] ?? 'N/A';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogEmail(
                        nameCourse: nameCourse,
                        dateInit: dateInit,
                        dateRegister: dateRegister,
                        sendDocument: dateSendDocument,
                        nameOre: oreSelected,
                        nameSare: sareSelected,
                        idOre: idOreSelected,
                        idSare: idSareSelected,
                      );
                    },
                  );
                } else {}

              },
               //Valor para mostrar en el icono de la función onAssign
              tooltipAssign: "Enviar correos",
              //Valores del icono para la funcion onAssign
              iconAssign: const Icon(Icons.outgoing_mail, color: Colors.blue,),
              idKey: idKey,
              onActive: isActive,
              // La `activateFunction` es una función de devolución de llamada que se activa cuando un
              // usuario desea activar (restaurar) un curso asignado específico en la tabla de curso.
              activateFunction: (String id) async {
                try {
                  await methodsDetailCourses.activarDetalleCurso(id);
                  refreshTable();
                  if (context.mounted) {
                    showCustomSnackBar(
                        context, "Curso restaurado correctamente", greenColorLight);
                  }
                } catch (e) {
                  if (context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              },
            );
          }
        },
      );
    });
  }
}