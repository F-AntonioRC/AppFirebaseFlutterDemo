import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/service/database.dart';

class AllEmployeeDetails extends StatelessWidget {
  final Stream? employeeStream;
  final TextEditingController nameController;
  final TextEditingController sexController;
  final TextEditingController RFCcontroller;
  final TextEditingController estadoController;
  final TextEditingController areaController;
  final TextEditingController sareController;
  final Function(String id, String depedency) editEmployeeCallback;

  const AllEmployeeDetails({
    required this.employeeStream,
    required this.nameController,
    required this.editEmployeeCallback,
    required this.sexController,
    required this.RFCcontroller,
    required this.areaController,
    required this.sareController,
    required this.estadoController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: employeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Column(
                  children: [
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: double.infinity,
                        // Aquí se ajusta el ancho al 100%
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Name: " + ds["Name"],
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    try {
                                      nameController.text = ds["Name"];
                                      //emailController.text = ds["Email"];
                                      editEmployeeCallback(
                                          ds["Id"], ds["Depedency"]);

                                      showCustomSnackBar(context,
                                          "Empleado editado correctamente");
                                    } catch (e) {
                                      showCustomSnackBar(context, "Error: $e");
                                    }
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Email: ",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    try {
                                      DatabaseMethods()
                                          .deleteEmployeeDetail(ds["Id"]);
                                      showCustomSnackBar(
                                          context, "Empleado eliminado");
                                    } catch (e) {
                                      showCustomSnackBar(context, "Error $e");
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_forever_sharp,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Dependency: " + ds["Depedency"],
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(color: Colors.black),
                  ],
                );
              });
        });
  }
}
