import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/dialogChanges.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';
import 'package:testwithfirebase/util/responsive.dart';

import '../components/my_table.dart';

class TableEmployee extends StatefulWidget {

  const TableEmployee({super.key});

  @override
  State<TableEmployee> createState() => _TableEmployeeState();
}

class _TableEmployeeState extends State<TableEmployee> {

  final DatabaseMethods databaseMethods = DatabaseMethods();
  final List<String> headers = ["Identificador", "Nombre Completo", "Estado", "Area", "Sare"];
  final List<String> fieldKeys = ["IdEmployee","Nombre", "Estado", "Area", "Sare"];

  bool viewInactivos = false; //VARIABLE PARA VER LOS EMPLEADOS INACTIVO

  String selectedEmployeeId = "";

  Future<List<Map<String, dynamic>>> fetchData() {
    return databaseMethods.getEmployeeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(10.0),
          child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Lista de Empleados",
                          style: TextStyle(
                              fontSize: responsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                          ), textAlign: TextAlign.center,
                        )
                        ),
                        Ink(
                          decoration: const ShapeDecoration(shape: CircleBorder(),
                              color: greenColor),
                          child: IconButton(onPressed: () {
                            setState(() {
                              viewInactivos = !viewInactivos; //ALTERNAR EL VALOR DE LOS DATOS MOSTRADOS
                            });
                          },
                              tooltip: viewInactivos ? "Mostrar Empleados Inactivos" : "Mostrar Empleados activos",
                              icon: Icon( viewInactivos ? Icons.visibility_off : Icons.visibility ,
                                color: Colors.white,)),
                        ),
                        const SizedBox(width: 10.0),
                      ],

                    ),
                    const Divider(),
                    FutureBuilder(
                        future: viewInactivos
                            ? databaseMethods.getEmployeeInact()
                            : databaseMethods.getEmployeeDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No employees found.'));
                          } else {
                            final data = snapshot.data!;
                            return MyTable(headers: headers,
                              data: data,
                              fieldKeys: fieldKeys,
                              onEdit: (String id) {  },
                              onDelete: (String id) async {
                                try {
                                  await databaseMethods.deleteEmployeeDetail(id);
                                  setState(() {});
                                  showCustomSnackBar(context, "Empleado eliminado Correctamente", greenColor);
                                } catch(e) {
                                  showCustomSnackBar(context, "Error: $e", Colors.red);
                                }
                              },
                              onAssign: (String id) {
                                showDialog(context: context,
                                    builder: (BuildContext context) {
                                      return const Dialogchanges(dataChange: 'Hola');
                                    });
                              },
                              idKey: 'IdEmployee',);
                          }
                        }),
                  ],
                )
              ),
          )
    )
    );
}
}
