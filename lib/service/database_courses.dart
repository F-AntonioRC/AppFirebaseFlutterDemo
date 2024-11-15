import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsCourses {
  //REGISTRAR UN NUEVO CURSO
  Future addCourse(Map<String, dynamic> courseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .set(courseInfoMap);
  }

  //OBTENER TODOS LOS CURSOS ACTIVOS
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Courses').where('Estado', isEqualTo: 'Activo').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER TODOS LOS CURSOS DESACTIVADOS
  Future<List<Map<String, dynamic>>> getAllCoursesInac() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Courses').where('Estado', isEqualTo: 'Inactivo').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER LOS ATRIBUTOS DE UN CURSO
  Future<DocumentSnapshot<Map<String, dynamic>>> getCourseEspecific(String? id) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .get();
  }

  //ACTULIZAR
  Future<void> updateCourse(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .update(updateInfo);
  }

  //ELIMINAR
  Future deleteCoursesDetail(String id) async {
    try{
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Courses').doc(id);
      await documentReference.update({'Estado' : 'Inactivo'});
    } catch(e) {
      print("Error: $e");
    }
  }
}
