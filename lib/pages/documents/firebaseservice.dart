import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener trimestres únicos
  Future<List<String>> getTrimesters() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Cursos').get();

      Set<String> uniqueTrimesters = {};
      for (var doc in snapshot.docs) {
        String? trimester = doc['Trimestre'];
        if (trimester != null) {
          uniqueTrimesters.add(trimester);
        }
      }

      return uniqueTrimesters.toList()..sort();
    } catch (e) {
      print('Error al obtener trimestres: $e');
      return [];
    }
  }

  // Obtener dependencias únicas por trimestre
  Future<List<Map<String, dynamic>>> getDependencies(String trimester) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Cursos')
          .where('Trimestre', isEqualTo: trimester)
          .get();

      Set<String> uniqueDependencies = {};
      List<Map<String, dynamic>> dependencies = [];

      for (var doc in snapshot.docs) {
        String idDependencia = doc['IdDependencia'];

        if (!uniqueDependencies.contains(idDependencia)) {
          uniqueDependencies.add(idDependencia);

          DocumentSnapshot dependenciaDoc =
              await _firestore.collection('Dependencia').doc(idDependencia).get();

          if (dependenciaDoc.exists) {
            dependencies.add({
              'IdDependencia': idDependencia,
              'NombreDependencia': dependenciaDoc['NombreDependencia'],
            });
          }
        }
      }

      return dependencies;
    } catch (e) {
      print('Error al obtener dependencias: $e');
      return [];
    }
  }

  // Obtener cursos por trimestre y dependencia
  Stream<QuerySnapshot> getCourses(String trimester, String dependecyId) {
    return _firestore
        .collection('Cursos')
        .where('Trimestre', isEqualTo: trimester)
        .where('IdDependencia', isEqualTo: dependecyId)
        .snapshots();
  }

  // Obtener archivos de un curso en Firebase Storage
  Future<Map<String, String>> getCourseFiles(
      String trimester, String dependency, String courseName) async {
    try {
      ListResult coursesList = await _storage
          .ref(
              '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/$trimester/$dependency/$courseName')
          .listAll();

      Map<String, String> files = {};
      for (Reference fileRef in coursesList.items) {
        String url = await fileRef.getDownloadURL();
        files[fileRef.name] = url;
      }

      return files;
    } catch (e) {
      print('Error al obtener archivos: $e');
      return {};
    }
  }
  Future<void>downloadFile(String fileUrl) async {
    final Uri uri = Uri.parse(fileUrl);
  
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se puede abrir el archivo';
    }
  }

}
