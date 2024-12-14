import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/MyPaginatedTable.dart';
import 'package:testwithfirebase/service/database.dart';
import '../../dataConst/constand.dart';
import '../custom_snackbar.dart';
import '../dialogChanges.dart';

class TableViewEmployee extends StatelessWidget {
  final bool viewInactivos;
  final List<Map<String, dynamic>> filteredData;
  final DatabaseMethods databaseMethods;
  final bool isActive;
  final Function() refreshTable;

  const TableViewEmployee({super.key,
    required this.viewInactivos,
    required this.filteredData,
    required this.databaseMethods,
    required this.isActive,
    required this.refreshTable});

  @override
  Widget build(BuildContext context) {
    const String idKey = "IdEmployee";

    return FutureBuilder(
      future: viewInactivos
          ? databaseMethods.getEmployeeInact()
          : databaseMethods.getEmployeeDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if ((!snapshot.hasData || snapshot.data!.isEmpty) &&
            filteredData.isEmpty) {
          return const Center(child: Text('No se encontraron empleados.'));
        } else {
          final data =
          filteredData.isEmpty ? snapshot.data! : filteredData;
          return MyPaginatedTable(
            headers: const ["Identificador", "CUPO", "Nombre Completo", "Estado", "Area", "Sare"],
            data: data,
            fieldKeys: const ["IdEmployee", "CUPO", "Nombre", "Estado", "Area", "Sare"],
            onEdit: (String id) {
              final selectedRow = data.firstWhere((row) => row[idKey] == id);
              final idChange = selectedRow[idKey];
              final name = selectedRow['Nombre'];
              final sareChange = selectedRow['Sare'];
              final areaChange = selectedRow['Area'];
              final sexChange = selectedRow['Sexo'];

            },
            onDelete: (String id) async {
              try {
                await databaseMethods.deleteEmployeeDetail(id);
                refreshTable();
                if(context.mounted) {
                  showCustomSnackBar(context, "Empleado eliminado Correctamente", greenColor);
                }
              } catch (e) {
                if(context.mounted) {
                  showCustomSnackBar(context, "Error: $e", Colors.red);
                }
              }
            },
            onAssign: (String id) {
              final selectedRow = data.firstWhere((row) => row[idKey] == id);
              final name = selectedRow["Nombre"];
              final idAdd = selectedRow[idKey];
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogChanges(dataChange: name, idChange: idAdd,);
                },
              );
            },
            tooltipAssign: "Asignar CUPO",
            idKey: idKey,
            onActive: isActive,
            activateFunction: (String id) async {
              try {
                await databaseMethods.activateEmployeeDetail(id);
                refreshTable();
                if(context.mounted) {
                  showCustomSnackBar(context, "Empleado restaurado Correctamente", greenColor);
                }
              } catch (e) {
                if(context.mounted) {
                  showCustomSnackBar(context, "Error: $e", Colors.red);
                }
              }
            }, iconAssign: const Icon(Icons.engineering, color: Colors.blue,),
          );
        }
      },
    );
  }
}
