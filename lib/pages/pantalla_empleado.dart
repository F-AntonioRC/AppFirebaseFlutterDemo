import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/employee/card_employee.dart';
import 'package:testwithfirebase/pages/empoyee.dart';

class PantallaEmpleado extends StatefulWidget {

   const PantallaEmpleado({super.key});

  @override
  State<PantallaEmpleado> createState() => _PantallaEmpleadoState();
}

class _PantallaEmpleadoState extends State<PantallaEmpleado> {
  Map<String, dynamic>? employeeData; //Estado Compartido

  void updateEmployeeData(Map<String, dynamic> newData) {
    setState(() {
      employeeData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: Employee( initialData: employeeData, )),
      const Expanded(child: CardEmployee())
    ],);
  }
}
