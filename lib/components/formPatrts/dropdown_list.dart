import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final List<String> items; // Lista de elementos para el dropdown
  final Function(String?)? onChanged; // Callback para obtener el valor seleccionado
  final Icon icon; // Icono mostrado en el dropdown
  final String? value; // Valor inicial seleccionado

  const DropdownList({
    super.key,
    required this.items,
    this.onChanged,
    required this.icon,
    this.value,
  });

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selectedValue; // Valor seleccionado

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value; // Inicializar con el valor externo
  }

  @override
  void didUpdateWidget(covariant DropdownList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        selectedValue = widget.value; // Actualizar si el valor externo cambia
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: selectedValue,
      icon: widget.icon,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade900),
              borderRadius: BorderRadius.circular(10.0))),
      hint: const Text("Seleccione una opción"),
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue; // Actualiza el valor seleccionado
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue); // Retorna el valor seleccionado al callback externo
        }
      },
      isExpanded: true, // Ocupa el espacio disponible
    );
  }
}
