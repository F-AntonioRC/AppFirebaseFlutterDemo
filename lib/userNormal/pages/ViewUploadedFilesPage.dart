import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Función para abrir un archivo PDF en el navegador
  Future<void> _viewPDFInBrowser(String fileUrl) async {
    final Uri pdfUri = Uri.parse(fileUrl);

    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(
        pdfUri,
        mode: LaunchMode.externalApplication,
        ); // Abre el PDF en el navegador predeterminado
    } else {
      throw 'No se puede abrir el archivo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de ${widget.courseName}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : files.isEmpty
              ? Center(child: Text('No hay archivos disponibles.'))
              : ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            file['name'] ?? 'Archivo ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.open_in_browser, color: Colors.blue),
                            onPressed: () => _viewPDFInBrowser(file['url']!),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
