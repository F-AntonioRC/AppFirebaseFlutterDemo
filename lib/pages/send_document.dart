import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendDocument extends StatefulWidget {
  final String course;
  SendDocument({required this.course, Key? key}) : super(key: key);

  @override
  State<SendDocument> createState() => _SendDocumentState();
}

class _SendDocumentState extends State<SendDocument> {
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
      String fileName = basename(result.files.single.name); // Nombre del archivo

      final storagePath=
      '2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE\'S/Cursos_2024/TRIMESTRE 1/${widget.course}/$fileName';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(storagePath); // Carpeta por usuario

      try {
        setState(() {
          isUploading = true; // Cambia el estado a "subiendo"
        });

        // Subir archivo
        if (result.files.single.bytes != null) {
          await storageRef.putData(result.files.single.bytes!);
        } else if (result.files.single.path != null) {
          File file = File(result.files.single.path!);
          await storageRef.putFile(file);
        }

        // Obtener la URL de descarga del archivo
        String downloadURL = await storageRef.getDownloadURL();

        //ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          //SnackBar(content: Text('Archivo subido exitosamente.')),
       // );
        print('URL del archivo: $downloadURL'); // Puedes almacenar esta URL en Firestore

      } catch (e) {
        print('Error al subir archivo: $e');
        //ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          //SnackBar(content: Text('Error al subir el archivo.')),
        //);
      } finally {
        setState(() {
          isUploading = false; // Cambia el estado a "no subiendo"
        });
      }
    } else {
     // ScaffoldMessenger.of(context as BuildContext).showSnackBar(
       //SnackBar(content: Text('No se seleccionó ningún archivo.')),
      //);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Document: ${widget.course}'),
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
                  // Verificar la existencia del documento
                  if (user != null) 
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid) 
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        if (snapshot.hasData && snapshot.data!.data() != null) {
                          var documentData = snapshot.data!.data() as Map<String, dynamic>;
                          if (documentData.containsKey('name')) {
                            return Text('Nombre del usuario: ${documentData['name']}');
                          } else {
                            return Text('El campo "name" no existe en este documento.');
                          }
                        } else {
                          return Text('No hay datos disponibles o el documento no existe.');
                        }
                      },
                    ),
                ],
              ),
      ),
    );
  }
}
