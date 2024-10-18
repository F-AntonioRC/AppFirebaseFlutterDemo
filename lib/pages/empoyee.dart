import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/service/database.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController rfcController = new TextEditingController();
  TextEditingController sexController = new TextEditingController();
  TextEditingController estadoController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController sareController = new TextEditingController();
  final FirebaseDropdownController _dropdownController = FirebaseDropdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Employee',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre del empleado',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            MyTextfileld(
                hindText: "Nombre Completo",
                icon: const Icon(Icons.person),
                controller: namecontroller,
                obsecureText: false,
                keyboardType: TextInputType.text),
            const SizedBox(height: 15.0),
            const Text(
              'Sexo',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            MyTextfileld(
                hindText: "Seleccione uno",
                icon: const Icon(Icons.email_rounded),
                controller: sexController,
                obsecureText: false,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15.0),
            const Text(
              'Depedency',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            FirebaseDropdown(
              controller: _dropdownController,
              collection: 'Dependency',
              data: 'Name',
              textHint: 'Select a dependency',),
            const SizedBox(height: 30.0),
            Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              icon: const Icon(Icons.add_circle, color: Colors.white,),
              iconAlignment: IconAlignment.start,
              onPressed: () async {
                try {
                  String id = randomAlphaNumeric(5);
                  Map<String, dynamic>? selectedDependency = _dropdownController.selectedDocument;
                  if(selectedDependency != null) {
                    String dependencyName = selectedDependency['Name'];
                    Map<String, dynamic> employeeInfoMap = {
                      "Id": id,
                      "Name": namecontroller.text,
                      "Email": sexController.text,
                      "Depedency": dependencyName
                    };
                    await DatabaseMethods()
                        .addEmployeeDetails(employeeInfoMap, id);
                    showCustomSnackBar(context, "Operacion completada");
                  }
                } catch (e) {
                  // Capturar cualquier error y mostrar un SnackBar con el mensaje de error
                  showCustomSnackBar(context, "Error: $e");
                }
              },
              label: const Text("Add", style: TextStyle(color: Colors.white),),
            ))
          ],
        ),
      ),
    );
  }
}