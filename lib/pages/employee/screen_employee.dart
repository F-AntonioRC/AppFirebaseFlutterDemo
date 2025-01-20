import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/employee/card_employee.dart';
import 'package:testwithfirebase/pages/employee/empoyee.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/database_methods_employee.dart';

class ScreenEmployee extends StatefulWidget {
  const ScreenEmployee({super.key});

  @override
  State<ScreenEmployee> createState() => _ScreenEmployeeState();
}

class _ScreenEmployeeState extends State<ScreenEmployee> {
  final DatabaseMethodsEmployee databaseMethods = DatabaseMethodsEmployee();
  
  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        Expanded(
            child: Employee(
          initialData: employeeProvider.data,
        )),
        const Expanded(child: CardEmployee())
      ],
    );
  }
}
