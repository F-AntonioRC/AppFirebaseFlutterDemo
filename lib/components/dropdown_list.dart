import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final List<String> items; //LISTA DE ELEMENTOS PARA EL DROPDOWN
  final Function(String?)? onChanged; //CALLBACK PARA OBTENER EL VALOR SELECCIONADO
  final Icon icon; //ITEM MOSTRADO EN EL DROPDOWN

  const DropdownList({super.key, required this.items, this.onChanged, required this.icon});

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selectedValue; //VALOR SELECCIONADO

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(
        value: selectedValue,
        icon: widget.icon,
        decoration: InputDecoration(
          contentPadding:  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(12.0)
          ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade900), borderRadius: BorderRadius.circular(12.0))
        ),
        hint: const Text("Seleccione una opción"),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          );
    }).toList(),
    onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged!(newValue); //RETORNA EL VALOR SELECCIONADO
    },
      isExpanded: true, // OCUPA EL ESPACIO DISPONIBLE
    );
  }
}
