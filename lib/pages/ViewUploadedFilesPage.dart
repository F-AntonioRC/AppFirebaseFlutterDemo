import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewUploadedFilesPage extends StatefulWidget {
  final String courseName; // Curso seleccionado para ver los archivos
  ViewUploadedFilesPage({required this.courseName, Key? key}) : super(key: key);

  @override
  _ViewUploadedFilesPageState createState() => _ViewUploadedFilesPageState();
}

class _ViewUploadedFilesPageState extends State<ViewUploadedFilesPage> {
  List<Map<String, String>> files = []; // Lista de archivos con nombre y URL
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  // Cargar los archivos desde Firebase Storage
  Future<void> _loadFiles() async {
    try {
      print('Curso seleccionado: ${widget.courseName}');
      FirebaseStorage storage = FirebaseStorage.instance;
      // Acceder a la ruta del curso
      
      Reference courseRef = storage.ref("2024/CAPACITACIONES_LISTA_ASISTENCIA_PAPEL_SARE'S/Cursos_2024/TRIMESTRE 1/${widget.courseName}");

      // Obtener los archivos en esa ruta
      ListResult result = await courseRef.listAll();

      List<Map<String, String>> loadedFiles = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        loadedFiles.add({'name': ref.name, 'url': url});
      }

      setState(() {
        files = loadedFiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los archivos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para descargar un archivo
  Future<void> _downloadFile(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'No se puede abrir el archivo';
    }
  }
   Future<void> _viewPDF(String fileUrl) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfUrl: fileUrl),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de ${widget.courseName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : files.isEmpty
              ? const Center(child: Text('No hay archivos disponibles.'))
              : ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return ListTile(
                      title: Text(file['name'] ?? 'Archivo ${index + 1}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => _downloadFile(file['url']!),
                      ),
                    );
                  },
                ),
    );
  }
}
class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previsualizar PDF"),
      ),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}