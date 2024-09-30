import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  //AGREGAR UN NUEVO EMPLEADO
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .set(employeeInfoMap);
  }

  //OBTENER TODOS LOS EMPLEADOS
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection('Employee').snapshots();
  }

  //ACTUALIZAR
  Future updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(id).update(updateInfo);
  }

  //ELIMINAR
  Future deleteEmployeeDetail(String id) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(id).delete();
  }

}
