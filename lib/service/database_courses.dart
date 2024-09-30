import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsCourses {

  //REGISTRAR UN NUEVO CURSO
  Future addCourse( Map<String, dynamic> courseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(id)
        .set(courseInfoMap);
  }

  //OBTENER TODOS LOS CURSOS
  Future<Stream<QuerySnapshot>> getAllCourses() async {
    return await FirebaseFirestore.instance.collection("Courses").snapshots();
  }

  //ACTULIZAR
  Future updateCourse(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection("Courses").doc(id).update(updateInfo);
  }

  //ELIMINAR
  Future deleteCourse(String id) async {
    return await FirebaseFirestore.instance.collection("Courses").doc(id).delete();
  }

}