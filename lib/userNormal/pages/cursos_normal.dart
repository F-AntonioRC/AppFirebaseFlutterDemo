import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class CursosNormal extends StatefulWidget {
  final String course; // Curso principal
  final String? subCourse; // Subcurso opcional
  final String trimester; // Trimestre al que pertenece

  CursosNormal({
    required this.course,
    this.subCourse,
    required this.trimester, // Nuevo parámetro para el trimestre
    Key? key,
  }) : super(key: key);

  @override
  State<CursosNormal> createState() => _CursosNormalState();
}

class _CursosNormalState extends State<CursosNormal> {
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

      // Construir la ruta de almacenamiento dinámicamente con el trimestre
      String storagePath = '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARES/Cursos_2024/${widget.trimester}/${widget.course}/';
      if (widget.subCourse != null) {
        storagePath += '${widget.subCourse}/';
      }
      storagePath += fileName;

      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final metadata = SettableMetadata(contentType: 'application/pdf');

      try {
        setState(() {
          isUploading = true;
        });

        // Subir archivo
        if (result.files.single.bytes != null) {
          await storageRef.putData(result.files.single.bytes!, metadata);
        } else if (result.files.single.path != null) {
          File file = File(result.files.single.path!);
          await storageRef.putFile(file, metadata);
        }

        // Obtener URL de descarga
        String downloadURL = await storageRef.getDownloadURL();

        // Agregar notificación al Firestore
        await FirebaseFirestore.instance.collection('notifications').add({
          'trimester': widget.trimester, // Trimestre
          'course': widget.course,
          'subCourse': widget.subCourse ?? 'Sin subcurso',
          'fileName': fileName,
          'uploader': user?.email ?? 'Usuario desconocido',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
          'pdfUrl': downloadURL,
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
        title: Text(widget.subCourse != null
            ? 'Subir Documento: ${widget.course} > ${widget.subCourse}'
            : 'Subir Documento: ${widget.course}'),
        backgroundColor: const Color(0xFF255946),
      ),
      body: Center(
        child: isUploading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.subCourse != null
                        ? 'Sube la evidencia del curso en formato PDF no mayor a 5MB para ${widget.trimester}.'
                        : 'Sube un documento PDF para el curso seleccionado (${widget.trimester}).',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
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
