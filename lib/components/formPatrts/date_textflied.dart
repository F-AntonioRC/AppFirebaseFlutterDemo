import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// La clase `DateTextField` es un StatefulWidget en dart que recibe como parametro:
/// controller tipo TextEditingController.
/// Permite a los usuarios seleccionar una fecha y
/// actualiza un controlador de texto con la fecha seleccionada en un formato específico.
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

/// Esta función crea un widget TextField con un ícono de calendario y una decoración específica
///  para seleccionar una fecha.
/// 
/// Devuelve:
/// Se devuelve un widget `TextField` con una decoración específica que incluye un ícono de prefijado,
/// hintText y estilo de borde. El `TextField` está configurado para ser de solo lectura 
/// y tiene una función `onTap` que llama a `_selectDate(context)` cuando se toca.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        hintText: 'Seleccione una fecha',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
              borderRadius: BorderRadius.circular(10.0))
      ),
      readOnly: true, 
      onTap: () => _selectDate(context),  
    );
  }
}
