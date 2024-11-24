import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

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
  _FirebaseDropdownState createState() {
    return _FirebaseDropdownState();
  }
}

class FirebaseDropdownController {
  Map<String, dynamic>? _selectedDocument;

  // Método para obtener el valor seleccionado
  Map<String, dynamic>? get selectedDocument => _selectedDocument;

  // Método para establecer el documento seleccionado
  void setDocument(Map<String, dynamic>? document) {
    _selectedDocument = document;
  }

  void clearSelection() {
    _selectedDocument = null;
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
    final theme = Theme.of(context);

    return Center(
      child: documentsList.isEmpty
          ? const CircularProgressIndicator()
          : DropdownButtonFormField<Map<String, dynamic>?>(
        dropdownColor: ligthBackground,
        decoration: InputDecoration(
            contentPadding:  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.hintColor),
                borderRadius: BorderRadius.circular(10.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.hintColor),
                borderRadius: BorderRadius.circular(10.0))
        ),
        value: widget.controller.selectedDocument == null
        ? null
            : documentsList.firstWhere(
              (doc) => doc == widget.controller.selectedDocument,
          orElse: () => documentsList.isNotEmpty ? documentsList[0] : {},
        ),
        hint: Text(widget.textHint),
        isExpanded: true,
        items: documentsList.map<DropdownMenuItem<Map<String, dynamic>?>>(
                (Map<String, dynamic> document) {
              return DropdownMenuItem<Map<String, dynamic>?>(
                value: document,
                child: Text(document[widget.data] ?? 'Sin datos'), // Mostrar solo el campo del nombre
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
