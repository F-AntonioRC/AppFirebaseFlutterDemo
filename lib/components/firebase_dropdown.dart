import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

    List<Map<String, dynamic>> fetchedDocuments = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['Id'] = doc.id; //Añadir el Id del documento a los datos
      return data;
    }).toList();

    setState(() {
      documentsList = fetchedDocuments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: documentsList.isEmpty
          ? const CircularProgressIndicator()
          : DropdownButtonFormField<Map<String, dynamic>>(
        decoration: InputDecoration(
            contentPadding:  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(12.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade900), borderRadius: BorderRadius.circular(12.0))
        ),
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
