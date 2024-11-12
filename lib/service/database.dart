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
  Future<List<Map<String, dynamic>>> getEmployeeDetails() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Employee').where('Estado', isEqualTo: 'Activo').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //ACTUALIZAR
  Future updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(id).update(updateInfo);
  }

  //ELIMINAR
  Future deleteEmployeeDetail(String id) async {
  try{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('Employee').doc(id);
    await documentReference.update({'Estado' : 'Inactivo'});
  } catch(e) {
    print("Error: $e");
  }
  }

}
