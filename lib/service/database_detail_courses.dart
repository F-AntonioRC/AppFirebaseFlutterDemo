import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsDetailCourses {

  //REGISTRAR UN DETALLE CURSO
  Future addDetailCourse(Map<String, dynamic> detailCourseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .set(detailCourseInfoMap);
  }

  //OBTENER TODOS LOS DETALLE CURSOS
  Future<List<Map<String, dynamic>>> getAllDetailCourses() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("DetalleCursos").get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  //OBTENER LOS ATRIBUTOS DE UN DETALLE CURSO
  Future<DocumentSnapshot<Map<String, dynamic>>> getDetailCourseEspecific(String? id) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .get();
  }

  //ACTULIZAR LOS DETALLE CURSOS
  Future<void> updateDetailCourse(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .update(updateInfo);
  }

  //ELIMINAR
  Future<void> deleteDetailCourse(String id) async {
    return await FirebaseFirestore.instance
        .collection("DetalleCursos")
        .doc(id)
        .delete();
  }
}