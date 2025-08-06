import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testwithfirebase/components/formPatrts/date_textflied.dart';

import 'package:testwithfirebase/userNormal/serviceuser/firebase_storage_service.dart';
import 'package:testwithfirebase/util/responsive.dart';

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
    super.key,
  });

  @override
  State<CursosNormal> createState() => _CursosNormalState();
}

class _CursosNormalState extends State<CursosNormal> {

    late TextEditingController
      dateController; // Controlador de la fecha de inicio del curso.

  final FirebaseStorageService _storageService = FirebaseStorageService();
  User? user;
  bool isUploading = false;
  double uploadProgress = 0.0;
  bool hasPendingFile = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    dateController = TextEditingController(); 
    _checkPendingFile();
  }

  @override
void dispose() {
  dateController.dispose(); 
  super.dispose();
}

    Future<void> _checkPendingFile() async {
    if (user != null) {
      bool pending = await _storageService.tieneArchivoPendiente(
        idCurso: widget.idCurso,
        uid: user!.uid,
      );
      setState(() {
        hasPendingFile = pending;
      });
    }
  }

  Future<void> _uploadPDF() async {
    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
    });

    await _storageService.subirArchivo(
      context: context,
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

       // Después de subir, volvemos a verificar si hay archivos pendientes
    await _checkPendingFile();
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

                        
                Padding(padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Seleccione la Fecha en la que completo el curso",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: responsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    DateTextField(controller: dateController),
                  ],
                ),
                ),

            // Botón de subida
            ElevatedButton.icon(
              onPressed: (isUploading || hasPendingFile) ? null : _uploadPDF, // Deshabilita si está subiendo
              icon: const Icon(Icons.upload_file),
              label: Text( hasPendingFile ? 'En revisión' : 'Seleccionar y Subir PDF' ),
            ),
          ],
        ),
      ),
    );
  }
}
