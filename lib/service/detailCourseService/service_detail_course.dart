import 'package:testwithfirebase/service/detailCourseService/database_detail_courses.dart';

class CourseService {
  Future<void> addDetailCourse({
    required String idDetailCourse,
    required String idCourse,
    required String idArea,
    required String idSare
}) async {
    try {
      Map<String, dynamic> detailCourseMap = {
        "IdDetailCourse": idDetailCourse,
        "IdCourse": idCourse,
        "IdArea": idArea,
        "IdSare": idSare,
        "Estado": "Activo"
      };
      await MethodsDetailCourses().addDetailCourse(detailCourseMap, idDetailCourse);
    } catch (e) {
      throw Exception("Error al añadir detalle del curso: $e");
    }
  }

}
