import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextField extends StatefulWidget {
  final TextEditingController controller;

  const DateTextField({super.key, required this.controller});

  @override
  _DateTextFieldState createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime(2000),   // Fecha mínima
      lastDate: DateTime(2100),    // Fecha máxima
    );

    if (picked != null) {
      setState(() {
        // Actualiza el controlador con la fecha seleccionada
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,  // Usa el controlador pasado
      decoration: InputDecoration(
        hintText: 'Select a date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      readOnly: true,  // El campo no es editable directamente
      onTap: () => _selectDate(context),  // Abre el DatePicker al tocar
    );
  }
}
