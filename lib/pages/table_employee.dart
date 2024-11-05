import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/database.dart';

import '../components/my_table.dart';

class TableEmployee extends StatefulWidget {
  const TableEmployee({super.key});

  @override
  State<TableEmployee> createState() => _TableEmployeeState();
}

class _TableEmployeeState extends State<TableEmployee> {
  final DatabaseMethods databaseMethods = DatabaseMethods();
  final List<String> headers = ["Id", "Nombre", "Estado", "Area", "Sare"];
  final List<String> fieldKeys = ["IdEmployee","Nombre", "Estado", "Area", "Sare"];

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Card(
        color: ligth,
        child: Padding(padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: databaseMethods.getEmployeeDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No employees found.'));
                } else {
                  final data = snapshot.data!;
                  return Expanded(child: MyTable(headers: headers,
                    data: data,
                    fieldKeys: fieldKeys,
                    onEdit: (String id) {  },
                    onDelete: (String id) {  },
                  onAssign: (String id) {
                    showDialog(context: context,
                        builder: (BuildContext) {
                      return Dialog(
                        child: Text("Id: $id"),
                      );
                        });
                  },));
                }
              })),
      ),
    );
}
}
