import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/decoration_dropdown.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';

class FirebaseDropdown extends StatefulWidget {
  final FirebaseDropdownController controller;
  final String collection;
  final String data;
  final String textHint;
  final bool enabled;

  const FirebaseDropdown({
    super.key,
    required this.controller,
    required this.collection,
    required this.data,
    required this.textHint,
    this.enabled = true,
  });

  @override
  State<FirebaseDropdown> createState() => _FirebaseDropdownState();
}

class _FirebaseDropdownState extends State<FirebaseDropdown> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  //Metodo para actualizar el estado cuando el controlador cambie
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(widget.collection).snapshots().map(
            (snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['Id'] = doc.id; // Agregar el ID del documento
            return data;
          }).toList();
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Indicador de carga
        }

        if (snapshot.hasError) {
          return Text(
            "Error al cargar los datos",
            style: TextStyle(color: theme.colorScheme.error),
          );
        }

        if (snapshot.hasData) {
          // Obtener la lista de documentos
          List<Map<String, dynamic>> fetchedDocuments = snapshot.data ?? [];

          // Diferir la sincronización para evitar conflictos con el ciclo de construcción
          Future.microtask(() {
            widget.controller.synchronizeSelection(fetchedDocuments);
          });

          if (fetchedDocuments.isEmpty) {
            return Text(
              'No hay datos disponibles',
              style: TextStyle(color: theme.colorScheme.error),
            );
          }

          return DropdownButtonFormField<Map<String, dynamic>?>(
            decoration: CustomInputDecoration.inputDecoration(context),
            dropdownColor: theme.cardColor,
            value: widget.controller.selectedDocument == null
                ? null
                : fetchedDocuments.firstWhere(
                  (doc) => doc['Id'] == widget.controller.selectedDocument?['Id'],
              orElse: () => {},
            ),
            hint: Text(widget.textHint),
            items: fetchedDocuments.map<DropdownMenuItem<Map<String, dynamic>?>>((document) {
              return DropdownMenuItem<Map<String, dynamic>?>(
                value: document,
                child: Text(document[widget.data] ?? 'Sin datos'),
              );
            }).toList(),
            onChanged: widget.enabled
            ? (Map<String, dynamic>? newValue) {
              if(newValue == null) {
                widget.controller.clearSelection();
              } else {
                widget.controller.setDocument(newValue);
              }
            }
            : null,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona un valor';
              }
              return null;
            },
          );
        }
        return Text(
          'Cargando datos...',
          style: TextStyle(color: theme.colorScheme.primary),
        );
      },
    );
  }
}