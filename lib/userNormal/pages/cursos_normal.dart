import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class CursosNormal extends StatefulWidget {
  final String course;
    CursosNormal({required this.course, Key? key}) : super(key: key);

  @override
  State<CursosNormal> createState() => _CursosNormal();
}

class _CursosNormal extends State<CursosNormal> {
  User? user; 
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String fileName = basename(result.files.single.name);
      final storagePath =
          '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE\'S/Cursos_2024/TRIMESTRE 1/${widget.course}/$fileName';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(storagePath);
      final metadata = SettableMetadata(contentType:'application/pdf');

      try {
        setState(() {
          isUploading = true;
        });

        if (result.files.single.bytes != null) {
          await storageRef.putData(result.files.single.bytes!, metadata);
        } else if (result.files.single.path != null) {
          File file = File(result.files.single.path!);
          await storageRef.putFile(file, metadata);
        }

        String downloadURL = await storageRef.getDownloadURL();
         await FirebaseFirestore.instance.collection('notifications').add({
          'course': widget.course, // Curso al que pertenece el archivo
          'fileName': fileName, // Nombre del archivo
          'uploader': user?.email ?? 'Usuario desconocido', // Quién subió el archivo
          'timestamp': FieldValue.serverTimestamp(),
          'isRead':false, // Marca de tiempo
          });
        print('Archivo subido: $downloadURL');
      } catch (e) {
        print('Error al subir el archivo: $e');
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    } else {
      print('No se seleccionó ningún archivo.');
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Documento: ${widget.course}'),
      ),
      body: Center(
        child: isUploading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sube un documento PDF para el curso seleccionado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _uploadPDF,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Seleccionar y Subir PDF'),
                  ),
                ],
              ),
      ),
    );
  }
}
