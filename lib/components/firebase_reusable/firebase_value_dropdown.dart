import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/decoration_dropdown.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';

class FirebaseValueDropdown extends StatefulWidget {
  final String collection; // Nombre de la colección en Firebase
  final String field; // Campo cuyo valor será mostrado en el dropdown
  final FirebaseValueDropdownController? controller;
  final String? initialValue; // Valor inicial para edición
  final ValueChanged<String> onChanged; // Callback para el valor seleccionado

  const FirebaseValueDropdown(
      {super.key,
      this.initialValue,
      required this.onChanged,
      required this.collection,
      required this.field,
        this.controller});

  @override
  State<FirebaseValueDropdown> createState() => _FirebaseValueDropdownState();
}

class _FirebaseValueDropdownState extends State<FirebaseValueDropdown> {
  String? selectedValue;
  late Future<List<String>> dropdownItems;

  @override
  void initState() {
    super.initState();
    // Inicializar el valor seleccionado desde el controlador o el inicial
    selectedValue = widget.controller?.selectedValue ?? widget.initialValue;
    // Actualizar el controlador con el valor inicial
    widget.controller?.setValue(selectedValue);
    // Cargar los elementos del dropdown
    dropdownItems = fetchDropdownItems();
  }

  Future<List<String>> fetchDropdownItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(widget.collection)
        .get();
    return snapshot.docs.map((doc) => doc[widget.field] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: dropdownItems, builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if(snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}'
            );
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No hay datos disponibles');
          }
          final items = snapshot.data!;
          
          return ValueListenableBuilder(
              valueListenable: widget.controller!,
              builder: (context, selectedValue, _) {
                return DropdownButtonFormField<String>(
                  decoration: CustomInputDecoration.inputDecoration(context),
                  value: selectedValue,
                  hint: const Text('Seleccione una opción'),
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });

                    // Actualizar el controlador si existe
                    if (newValue != null) {
                      widget.controller?.setValue(newValue);
                      widget.onChanged(newValue); // Notificar el cambio
                    }
                  },

                );
              });
    }
    );
  }
}
