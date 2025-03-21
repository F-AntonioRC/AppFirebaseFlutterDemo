import 'package:flutter/material.dart';
import 'package:testwithfirebase/pages/documents/firebaseservice.dart';

class FilesListPage extends StatefulWidget {
  final String courseName; // Renombrado a courseName
  final String dependency;
  final String trimester;

  const FilesListPage({
    super.key,
    required this.courseName,
    required this.dependency,
    required this.trimester,
  });

  @override
  State<FilesListPage> createState() => _FilesListPageState();
}
class _FilesListPageState extends State<FilesListPage> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, String> files = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
    
  }

  Future<void> _loadFiles() async {
    files = await _firebaseService.getCourseFiles(
        widget.trimester, widget.dependency, widget.courseName);
    setState(() => isLoading = false);
  }
  
  Future<void> _downloadFile(String fileUrl) async {
    await _firebaseService.downloadFile(fileUrl);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de ${widget.courseName}'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : files.isEmpty
              ? const Center(
                  child: Text('No hay archivos disponibles.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    String fileName = files.keys.elementAt(index);
                    String fileUrl = files[fileName]!;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        title: Text(
                          fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => _downloadFile(fileUrl),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
