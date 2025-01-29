import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/decoration_dropdown.dart';
import 'package:testwithfirebase/components/firebase_reusable/firebase_value_dropdown_controller.dart';

  /// La clase `FirebaseValueDropdown` es un widget de selección desplegable (`DropdownButtonFormField`)
  /// que obtiene sus opciones desde una colección de Firebase Firestore.
  /// /// Este widget se actualiza automáticamente si cambia la colección o el valor inicial.
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
  late Future<List<String>> dropdownItems; // Lista de elementos para el dropdown
  String? selectedValue; // Valor seleccionado actualmente
  late String currentCollection; // Colección actual en Firebase

  @override
  void initState() {
    super.initState();
    currentCollection = widget.collection;
    selectedValue = widget.initialValue;
    dropdownItems = fetchDropdownItems(currentCollection);

    // Sincronizar el valor inicial con el controlador
    widget.controller?.setValue(widget.initialValue);

    // Escuchar cambios en el controlador y actualizar la UI
    widget.controller?.addListener(() {
      if(mounted) {
        setState(() {
          selectedValue = widget.controller?.selectedValue;
        });
      }
    });
  }

  // Eliminar el listener del controlador para evitar fugas de memoria
  @override
  void dispose() {
    widget.controller?.removeListener(() {});
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FirebaseValueDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Validacion si cambia la colección, actualiza la lista de elementos
    if (widget.collection != oldWidget.collection) {
      setState(() {
        currentCollection = widget.collection;
        dropdownItems = fetchDropdownItems(currentCollection);
      });
    }

    // Si cambia el valor inicial, actualiza la selección
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedValue = widget.initialValue;
      });
      widget.controller?.setValue(widget.initialValue);
    }
  }

  /// La funcion `fetchDropdownItems` obtiene los valores únicos del campo especificado dentro de la colección de Firebase.
  ///
  /// Retorna una lista de strings con los valores disponibles en el dropdown.
  Future<List<String>> fetchDropdownItems(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.map((doc) => doc[widget.field] as String).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: dropdownItems,
      builder: (context, snapshot) {
        // Validaciones para el estado de carga de los datos
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Indicador de carga
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); //Mensaje de error
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay datos disponibles'); // Mensaje de error
        }
        final items = snapshot.data!.toSet().toList();
        // Si el valor seleccionado no está en la lista, resetearlo
        if (selectedValue != null && !items.contains(selectedValue)) {
          selectedValue = null;
        }

        return DropdownButtonFormField<String>(
          decoration: CustomInputDecoration.inputDecoration(context),
          value: selectedValue,
          hint: const Text('Seleccione una opción'),
          items: items.map<DropdownMenuItem<String>>((String value) {
            //Mostrar los valores de la coleccion en el DropdownMenuItem
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // Validacion de los datos y actualizar el estado interno del widget
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
