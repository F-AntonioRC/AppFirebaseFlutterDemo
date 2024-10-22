import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsCourses {
  //REGISTRAR UN NUEVO CURSO
  Future addCourse(Map<String, dynamic> courseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .set(courseInfoMap);
  }

  //OBTENER TODOS LOS CURSOS
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Courses").get();
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
  Future<void> deleteCourse(String id) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .delete();
  }
}
