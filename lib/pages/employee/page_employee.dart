import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/pages/employee/Employee_controller.dart';
import 'package:testwithfirebase/pages/employee/employeeForm.dart';
import 'package:testwithfirebase/pages/employee/employee_actions.dart';
import 'package:testwithfirebase/pages/employee/employee_header.dart';

class PageEmployee extends StatelessWidget {
  final Map<String, dynamic>? initialData;

  const PageEmployee({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => EmployeeController(initialData),
    child: Container(
      margin: const EdgeInsets.all(10.0),
      child: const Padding(padding: EdgeInsets.all(10.0),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EmployeeHeader(),
                SizedBox(height: 20),
                EmployeeForm(),
                SizedBox(height: 20),
                EmployeeActions(),
              ],
            ),
          ),
        ),),
    ),
    );
  }
}
