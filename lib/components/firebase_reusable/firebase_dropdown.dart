import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/decoration_dropdown.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_dropdown_controller.dart';

/// La clase `FirebaseDropdown``es widget que muestra un `DropdownButtonFormField` dinámico, cargando 
/// valores desde la base de datos en tiempo real.
///
/// Este dropdown permite seleccionar un documento de una colección específica en Firebase y sincroniza 
/// la selección con un controlador personalizado (`FirebaseDropdownController`).
class FirebaseDropdown extends StatefulWidget {
  final FirebaseDropdownController controller; // Controlador para gestionar la selección del dropdown.
  final String collection; // Nombre de la colección en Firestore desde donde se obtendrán los datos
  final String data; // Clave del campo en los documentos que se usará como etiqueta en el dropdown.
  final String textHint; // Texto que se mostrará como hint cuando no haya selección.
  final bool enabled; // Habilita o deshabilita la interacción con el dropdown.

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

  //Agrega un listener al controller para que cuando cambie el estado del controlador, 
  //se llame a _updateState() y se redibuje el widget cuando el controlador cambia.
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  // La funcion dispose() se ejecuta cuando el widget es eliminado de la interfaz y su State 
  //ya no es necesario.
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
      /// Escucha en tiempo real los documentos de la colección de Firestore.
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
          return const CircularProgressIndicator(); // Muestra un indicador de carga.
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

          // Mostrar un mensaje cuando no se obtengan datos 
          if (fetchedDocuments.isEmpty) {
            return Text(
              'No hay datos disponibles',
              style: TextStyle(color: theme.colorScheme.error),
            );
          }

          return DropdownButtonFormField<Map<String, dynamic>?>(
            decoration: CustomInputDecoration.inputDecoration(context),
            dropdownColor: theme.cardColor,
            // Define el valor seleccionado basado en el controlador.
            value: widget.controller.selectedDocument == null
                ? null
                : fetchedDocuments.firstWhere(
                  (doc) => doc['Id'] == widget.controller.selectedDocument?['Id'],
              orElse: () => {},
            ),
            hint: Text(widget.textHint),
            // Genera las opciones del dropdown a partir de los documentos.
            items: fetchedDocuments.map<DropdownMenuItem<Map<String, dynamic>?>>((document) {
              return DropdownMenuItem<Map<String, dynamic>?>(
                value: document,
                child: Text(document[widget.data] ?? 'Sin datos'),
              );
            }).toList(),
            // Maneja los cambios de selección.
            onChanged: widget.enabled
            ? (Map<String, dynamic>? newValue) {
              if(newValue == null) {
                widget.controller.clearSelection();
              } else {
                widget.controller.setDocument(newValue);
              }
            }
            : null,
            // Validacion para la seleccion de un valor.
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