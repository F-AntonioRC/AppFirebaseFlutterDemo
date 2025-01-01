import 'package:flutter/material.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../dataConst/constand.dart';
import 'custom_snackbar.dart';
import 'my_button.dart';

class CustomDialog extends StatefulWidget {
  final String? dataOne;
  final String? dataTwo;
  final VoidCallback accept;
  final String messageSuccess;

  const CustomDialog({super.key,
    required this.accept,
    this.dataOne,
    this.dataTwo, required this.messageSuccess});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late TextEditingController _dataOneController;

  late TextEditingController _dataTwoController;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el valor de dataChange
    _dataOneController = TextEditingController(text: widget.dataOne);
    _dataTwoController = TextEditingController(text: widget.dataTwo);
  }

  @override
  void dispose() {
    // Libera el controlador para evitar fugas de memoria
    _dataOneController.dispose();
    _dataTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: const Text("¿Esta seguro que la selección en correcta?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(widget.dataOne != null)
            Text("Curso seleccionado",
              style: TextStyle(fontSize: responsiveFontSize(context, 15), fontWeight: FontWeight.bold),),
            const SizedBox(height: 10.0),
            TextField(
                readOnly: true,
                controller: _dataOneController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                        borderRadius: BorderRadius.circular(10.0))
                )
            ),
          const SizedBox(height: 10.0),
          if(widget.dataTwo != null)
            Text("Area/Sare asigando",
              style: TextStyle(fontSize: responsiveFontSize(context, 15), fontWeight: FontWeight.bold),),
          const SizedBox(height: 10.0),
          TextField(
              readOnly: true,
              controller: _dataTwoController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0))
              )
          ),
        ],
      ),
      actions: [
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    MyButton(text: "Aceptar", icon: const Icon(Icons.check_circle_outline),
      buttonColor: greenColor, onPressed: () {
        try {
          widget.accept();
          if (context.mounted) {
            showCustomSnackBar(
                context, widget.messageSuccess, greenColor);
          }
        } catch (e) {
          if (context.mounted) {
            showCustomSnackBar(
                context, "Error: $e", Colors.red);
          }
        }
        Navigator.of(context).pop();
      },),
    const SizedBox(width: 10.0),
    MyButton(
      text: "Cancelar",
      icon: const Icon(Icons.cancel_outlined),
      onPressed: () {
        Navigator.of(context).pop();
      },
      buttonColor: Colors.red,
    ),
  ],
)
      ],
    );
  }
}