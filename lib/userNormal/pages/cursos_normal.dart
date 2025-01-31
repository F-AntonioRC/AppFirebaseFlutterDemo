import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:testwithfirebase/userNormal/serviceuser/firebase_storage_service.dart';

class CursosNormal extends StatefulWidget {
  final String course;
  final String? subCourse;
  final String trimester;
  final String dependecy;
  final String idCurso;

  const CursosNormal({
    required this.course,
    this.subCourse,
    required this.trimester,
    required this.dependecy,
    required this.idCurso,
    Key? key,
  }) : super(key: key);

  @override
  State<CursosNormal> createState() => _CursosNormalState();
}

class _CursosNormalState extends State<CursosNormal> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  User? user;
  bool isUploading = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _uploadPDF() async {
    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
    });

    await _storageService.subirArchivo(
      trimester: widget.trimester,
      dependency: widget.dependecy,
      course: widget.course,
      idCurso: widget.idCurso,
      subCourse: widget.subCourse,
      onProgress: (progress) {
        setState(() {
          uploadProgress = progress;
        });
      },
    );

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCourse != null
            ? 'Subir Documento: ${widget.course} > ${widget.subCourse}'
            : 'Subir Documento: ${widget.course}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.subCourse != null
                  ? 'Sube la evidencia del curso en formato PDF para ${widget.trimester}, Dependencia: ${widget.dependecy}.'
                  : 'Sube un documento PDF para el curso seleccionado (${widget.course}).',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Barra de progreso
            if (isUploading)
              Column(
                children: [
                  LinearProgressIndicator(value: uploadProgress),
                  const SizedBox(height: 10),
                  Text('${(uploadProgress * 100).toStringAsFixed(0)}%'),
                ],
              ),

            const SizedBox(height: 20),

            // Botón de subida
            ElevatedButton.icon(
              onPressed: isUploading ? null : _uploadPDF, // Deshabilita si está subiendo
              icon: const Icon(Icons.upload_file),
              label: const Text('Seleccionar y Subir PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
