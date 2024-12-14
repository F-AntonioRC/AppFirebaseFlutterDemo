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

  Future<List<DocumentSnapshot>> obtenerSugerencias(String query) async {
    try {
      QuerySnapshot resultado = await FirebaseFirestore.instance
          .collection('Employee')
          .where('Nombre', isGreaterThanOrEqualTo: query)
          .where('Nombre', isLessThanOrEqualTo: '$query\uf8ff') // Limitar al rango
          .limit(5) // Limitar a cinco resultados
          .get();

      return resultado.docs;
    } catch (e) {
      print('Error al obtener sugerencias: $e');
      return [];
    }
  }

  //OBTENER TODOS LOS EMPLEADOS ACTIVOS
  Future<List<Map<String, dynamic>>> getEmployeeDetails() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Employee')
        .where('Estado', isEqualTo: 'Activo').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER TODOS LOS EMPLEADOS
  Future<List<Map<String, dynamic>>> getEmployeeInact() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Employee')
        .where('Estado', isEqualTo: 'Inactivo').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //ACTUALIZAR
  Future<void> updateEmployeeDetail(String id, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(id)
          .update(updatedData);
    } catch (e) {
      throw Exception("Error al actualizar el empleado: $e");
    }
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

  //ACTIVAR
  Future activateEmployeeDetail(String id) async {
    try{
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Employee').doc(id);
      await documentReference.update({'Estado' : 'Activo'});
    } catch(e) {
      print("Error: $e");
    }
  }

  //BUSCAR UN EMPLEADO
  Future<List<Map<String, dynamic>>> searchEmployeesByName(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('Nombre', isGreaterThanOrEqualTo: name)
        .where('Nombre', isLessThan: '${name}z') // Para búsquedas "que empiezan con minuscula"
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  //AGREGAR CUPO A UN EMPLEADO
  static Future<void> addEmployeeCupo(String employeeId, String cupo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .update({'CUPO' : cupo});
    } catch (e) {
      throw Exception('Error al actualizar CUPO: $e');
    }
  }

}
