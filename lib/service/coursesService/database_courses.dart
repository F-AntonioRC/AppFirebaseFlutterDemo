import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsCourses {
  //REGISTRAR UN NUEVO CURSO
  Future addCourse(Map<String, dynamic> courseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Cursos")
        .doc(id)
        .set(courseInfoMap);
  }

  //OBTENER TODOS LOS CURSOS ACTIVOS E INACTIVOS
  Future<List<Map<String, dynamic>>> getDataCourses(bool active) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Cursos')
        .where('Estado', isEqualTo: active ? 'Activo' : 'Inactivo')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  //ACTIVAR
  Future activateCoursesDetail(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Cursos').doc(id);
      await documentReference.update({'Estado': 'Activo'});
    } catch (e) {
      print("Error: $e");
    }
  }

  //ACTULIZAR
  Future<void> updateCourse(String id, Map<String, dynamic> updateData) async {
    if (id.isEmpty || updateData.isEmpty) {
      throw Exception("El ID o los datos están vacíos.");
    }
    try {
      return await FirebaseFirestore.instance
          .collection("Cursos")
          .doc(id)
          .update(updateData);
    } catch (e) {
      throw Exception("Error al actualizar el curso: $e");
    }
  }

  //ELIMINAR
  Future deleteCoursesDetail(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Cursos').doc(id);
      await documentReference.update({'Estado': 'Inactivo'});
    } catch (e) {
      print("Error: $e");
    }
  }

  //BUSCAR UN CURSO
  Future<List<Map<String, dynamic>>> searchCoursesByName(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Cursos')
        .where('NombreCurso', isGreaterThanOrEqualTo: name)
        .where('NombreCurso',
            isLessThan:
                '${name}z') // Para búsquedas "que empiezan con minuscula"
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
