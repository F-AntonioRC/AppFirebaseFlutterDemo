import 'package:flutter/material.dart';
import 'package:testwithfirebase/service/database.dart';

//ATRIBUTOS REQUERIDOS PARA EDITAR EL EMPLEADO
Future editEmployeeDetail({
  required BuildContext context,
  required String id,
  required TextEditingController nameController,
  //required TextEditingController emailController,
  required String currentDependency,
}) {
  //DIALOG CON LOS DATOS PARA LA EDICIÓN Y MODIFICACION DEL EMPLEADO
  return showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Name',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Email',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.0)),
                child: const TextField(
                  //controller: emailController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Dependency',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButton<String>(
                value: currentDependency,
                hint: const Text('Select Dependency'),
                isExpanded: true,
                items: <String>['Turismo', 'Bienestar', 'Medio ambiente']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    currentDependency = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> updateInfo = {
                      "Id": id,
                      "Name": nameController.text,
                      //"Email": emailController.text,
                      "Depedency": currentDependency,
                    };
                    await DatabaseMethods()
                        .updateEmployeeDetail(id, updateInfo)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
