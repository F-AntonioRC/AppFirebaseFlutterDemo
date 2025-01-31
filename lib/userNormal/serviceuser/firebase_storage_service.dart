import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Método para subir archivos PDF con barra de progreso y validaciones.
  Future<void> subirArchivo({
    required String trimester,
    required String dependency,
    required String course,
    required String idCurso,
    String? subCourse,
    required Function(double) onProgress, // Callback para actualizar la UI
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      print('No se seleccionó ningún archivo.');
      return;
    }

    String fileName = basename(result.files.single.name);
    String storagePath = '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/$trimester/$dependency/$course/';

    if (subCourse != null) {
      storagePath += '$subCourse/';
    }
    storagePath += fileName;

    final storageRef = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(contentType: 'application/pdf');

    try {
      // Obtener usuario autenticado
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      // Verificar si el archivo ya existe en Firebase Storage
      try {
        await storageRef.getDownloadURL();
        print('Archivo ya existe en Firebase Storage.');
        return;
      } catch (e) {
        print('Archivo no existe, procediendo a subirlo.');
      }

      UploadTask uploadTask;

      if (result.files.single.bytes != null) {
        uploadTask = storageRef.putData(result.files.single.bytes!, metadata);
      } else if (result.files.single.path != null) {
        File file = File(result.files.single.path!);
        uploadTask = storageRef.putFile(file, metadata);
      } else {
        print('No se pudo obtener los datos del archivo.');
        return;
      }

      // Monitorear el progreso de la subida
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        onProgress(progress);
      });

      // Esperar a que termine la subida
      await uploadTask;

      // Obtener URL de descarga
      String downloadURL = await storageRef.getDownloadURL();

      // Guardar información en Firestore
      await _firestore.collection('notifications').add({
        'trimester': trimester,
        'dependecy': dependency,
        'course': course,
        'IdCurso': idCurso,
        'uid': user.uid,
        'subCourse': subCourse ?? 'Sin subcurso',
        'fileName': fileName,
        'uploader': user.email ?? 'Usuario desconocido',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'pdfUrl': downloadURL,
      });

      print('Archivo subido exitosamente: $downloadURL');
    } catch (e) {
      print('Error al subir el archivo: $e');
    }
  }
}
