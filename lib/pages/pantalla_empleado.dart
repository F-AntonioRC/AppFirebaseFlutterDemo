import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/pages/empoyee.dart';
import 'package:testwithfirebase/pages/table_employee.dart';

class PantallaEmpleado extends StatefulWidget {
  const PantallaEmpleado({super.key});

  @override
  State<PantallaEmpleado> createState() => _PantallaEmpleadoState();
}

class _PantallaEmpleadoState extends State<PantallaEmpleado> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Expanded(child: Employee()),
      Expanded(child: TableEmployee())
    ],);
  }
}
