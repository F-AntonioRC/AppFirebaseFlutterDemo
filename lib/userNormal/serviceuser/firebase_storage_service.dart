import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> subirArchivo({
    required BuildContext context,
    required String trimester,
    required String dependency,
    required String course,
    required String idCurso,
    String? subCourse,
    required Function(double) onProgress,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No se seleccionó archivo'),
          content: Text('Debes seleccionar un archivo para continuar.'),
          actions: [
            MyButton(text: "Aceptar", icon: Icon(Icons.check_circle_outline), buttonColor: greenColorLight, onPressed: () => Navigator.pop(context),),
          ],
        ),
      );
      return;
    }

    String fileName = basename(result.files.single.name);
    String storagePath = '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/$trimester/$dependency/$course/';
    if (subCourse != null) storagePath += '$subCourse/';
    storagePath += fileName;

    final storageRef = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(contentType: 'application/pdf');

    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("Usuario no autenticado");

      try {
        await storageRef.getDownloadURL();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Archivo existente'),
            content: Text('El archivo ya existe en el almacenamiento.'),
            actions: [MyButton(text: "Aceptar", icon: Icon(Icons.check_circle_outline), buttonColor: greenColorLight, onPressed: () => Navigator.pop(context),)],
          ),
        );
        return;
      } catch (_) {}

      UploadTask uploadTask;
      if (result.files.single.bytes != null) {
        uploadTask = storageRef.putData(result.files.single.bytes!, metadata);
      } else if (result.files.single.path != null) {
        File file = File(result.files.single.path!);
        uploadTask = storageRef.putFile(file, metadata);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo obtener los datos del archivo.'),
            actions: [MyButton(text: "Aceptar", icon: Icon(Icons.check_circle_outline), buttonColor: greenColorLight, onPressed: () => Navigator.pop(context),)],
          ),
        );
        return;
      }

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        onProgress(progress);
      });

      await uploadTask;
      String downloadURL = await storageRef.getDownloadURL();

      await _firestore.collection('notifications').add({
        'estado': 'pendiente',
        'trimester': trimester,
        'dependecy': dependency,
        'course': course,
        'IdCurso': idCurso,
        'uid': user.uid,
        'fileName': fileName,
        'uploader': user.email ?? 'Usuario desconocido',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'pdfUrl': downloadURL,
        'filePaht': storagePath,
        'status': 'activo',
        'statusUser':'activo',
        'mensajeAdmin': '',
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('El archivo se subió correctamente.'),
          actions: [
            MyButton(text: "Aceptar", icon: Icon(Icons.check_circle_outline), buttonColor: greenColorLight, onPressed: () => Navigator.pop(context),)

          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error al subir'),
          content: Text('Error al subir el archivo: $e'),
          actions: [
            MyButton(text: "Aceptar", icon: Icon(Icons.check_circle_outline), buttonColor: greenColorLight, onPressed: () => Navigator.pop(context),)
            ],
        ),
      );
    }
  }
}
