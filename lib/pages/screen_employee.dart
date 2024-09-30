import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/all_employee_details.dart';

import '../service/database.dart';
import '../service/edit_employee_details.dart';

class ScreenEmployee extends StatefulWidget {
  const ScreenEmployee({super.key});

  @override
  State<ScreenEmployee> createState() => _ScreenEmployeeState();
}

class _ScreenEmployeeState extends State<ScreenEmployee> {

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();

  String? selectedDependency;

  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        const Text(
          'List of Employees',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Expanded(
          child: Padding(padding: const EdgeInsets.all(15.0), child:
          AllEmployeeDetails(
            employeeStream: EmployeeStream,
            nameController: namecontroller,
            emailController: emailcontroller,
            editEmployeeCallback:
                (String id, String currentDependency) {
              editEmployeeDetail(
                  context: context,
                  id: id,
                  nameController: namecontroller,
                  emailController: emailcontroller,
                  currentDependency: currentDependency);
            },
          ),)
          //allEmployeeDetails()
          ,
        ),
      ],
    );
  }
}
