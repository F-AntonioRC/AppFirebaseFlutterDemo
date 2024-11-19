import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDropdown extends StatefulWidget {
  final FirebaseDropdownController controller;
  final String collection;
  final String data;
  final String textHint;

  const FirebaseDropdown({
    super.key,
    required this.controller,
    required this.collection,
    required this.data,
    required this.textHint,
  });

  @override
  _FirebaseDropdownState createState() => _FirebaseDropdownState();
}

class FirebaseDropdownController {
  Map<String, dynamic>? _selectedDocument;

  // Método para obtener el valor seleccionado
  Map<String, dynamic>? get selectedDocument => _selectedDocument;

  // Método para establecer el documento seleccionado
  void setDocument(Map<String, dynamic>? document) {
    _selectedDocument = document;
  }
}

class _FirebaseDropdownState extends State<FirebaseDropdown> {
  List<Map<String, dynamic>> documentsList = [];

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(widget.collection).get();

    List<Map<String, dynamic>> fetchedDocuments = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      documentsList = fetchedDocuments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: documentsList.isEmpty
          ? const CircularProgressIndicator()
          : DropdownButton<Map<String, dynamic>>(
        value: widget.controller.selectedDocument,
        hint: Text(widget.textHint),
        isExpanded: true,
        items: documentsList.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> document) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: document,
                child: Text(document[widget.data]), // Mostrar solo el campo del nombre
              );
            }).toList(),
        onChanged: (Map<String, dynamic>? newValue) {
          setState(() {
            widget.controller.setDocument(newValue);
          });
        },
      ),
    );
  }
}
