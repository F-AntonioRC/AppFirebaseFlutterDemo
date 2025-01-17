import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/decoration_dropdown.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';

class FirebaseValueDropdown extends StatefulWidget {
  final String collection; // Nombre de la colección en Firebase
  final String field; // Campo cuyo valor será mostrado en el dropdown
  final FirebaseValueDropdownController? controller;
  final String? initialValue; // Valor inicial para edición
  final ValueChanged<String> onChanged; // Callback para el valor seleccionado

  const FirebaseValueDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.collection,
    required this.field,
    this.controller,
  });

  @override
  State<FirebaseValueDropdown> createState() => _FirebaseValueDropdownState();
}

class _FirebaseValueDropdownState extends State<FirebaseValueDropdown> {
  late Future<List<String>> dropdownItems;
  String? selectedValue;
  late String currentCollection;

  @override
  void initState() {
    super.initState();
    currentCollection = widget.collection;
    selectedValue = widget.initialValue;
    dropdownItems = fetchDropdownItems(currentCollection);

    // Sincronizar el valor inicial con el controlador
    widget.controller?.setValue(widget.initialValue);

    widget.controller?.addListener(() {
      if(mounted) {
        setState(() {
          selectedValue = widget.controller?.selectedValue;
        });
      }
    });
  }

  @override
  void dispose() {
    // Eliminar el listener del controlador
    widget.controller?.removeListener(() {});
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FirebaseValueDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detectar cambios en la colección
    if (widget.collection != oldWidget.collection) {
      setState(() {
        currentCollection = widget.collection;
        dropdownItems = fetchDropdownItems(currentCollection);
      });
    }

    // Detectar cambios en el valor inicial
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedValue = widget.initialValue;
      });
      widget.controller?.setValue(widget.initialValue);
    }
  }

  Future<List<String>> fetchDropdownItems(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.map((doc) => doc[widget.field] as String).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: dropdownItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay datos disponibles');
        }
        final items = snapshot.data!.toSet().toList();

        if (selectedValue != null && !items.contains(selectedValue)) {
          selectedValue = null;
        }

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
            if (newValue != null) {
              setState(() {
                selectedValue = newValue;
              });
              widget.controller?.setValue(newValue);
              widget.onChanged(newValue); // Notifica el cambio
            }
          },
        );
      },
    );
  }
}
