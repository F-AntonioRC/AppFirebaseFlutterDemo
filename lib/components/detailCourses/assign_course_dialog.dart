import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../../dataConst/constand.dart';
import '../formPatrts/custom_snackbar.dart';

/// `AssignCourseDialog`
/// Un widget que muestra un cuadro de diálogo (dialog) utilizado para confirmar
/// la selección de un curso y su asignación, con detalles adicionales relacionados.
class AssignCourseDialog extends StatefulWidget {
  final String? dataOne; //Un `String?` opcional que representa el curso seleccionado.
  final String? dataTwo; //Un `String?` opcional que representa el ORE asignado.
  final String? dataThree; //Un `String?` opcional que representa el Sare asignado.
  final VoidCallback accept; //Requerido para la acción a ejecutar cuando se confirma la asignación.
  final String messageSuccess; //Un `String` requerido que contiene el mensaje a mostrar en caso de éxito.

  const AssignCourseDialog(
      {super.key,
      required this.accept,
      this.dataOne,
      this.dataTwo,
      required this.messageSuccess,
      this.dataThree});

  @override
  State<AssignCourseDialog> createState() => _AssignCourseDialogState();
}

class _AssignCourseDialogState extends State<AssignCourseDialog> {
  // Controladores para los campos del diálogo
  late TextEditingController _dataOneController;
  late TextEditingController _dataTwoController;
  late TextEditingController _dataThreeController;

  /// Inicialización de los controladores para los campos de texto
  /// Los valores iniciales de los controladores se asignan desde las propiedades 
  /// `dataOne`, `dataTwo` y `dataThree`.
  @override
  void initState() {
    super.initState();
    _dataOneController = TextEditingController(text: widget.dataOne);
    _dataTwoController = TextEditingController(text: widget.dataTwo);
    _dataThreeController = TextEditingController(text: widget.dataThree);
  }

  /// Limpieza de recursos: Libera los controladores para evitar fugas de memoria.
  @override
  void dispose() {
    _dataOneController.dispose();
    _dataTwoController.dispose();
    _dataThreeController.dispose();
    super.dispose();
  }

  /// Construcción del widget principal.
  /// Muestra un `AlertDialog` con los detalles del curso seleccionado y opciones para confirmar o cancelar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: const Text("¿Esta seguro que la selección en correcta?"),
      content: Column(
        children: [
          // Muestra el curso seleccionado, si está definido.
          if (widget.dataOne != null)
            Text(
              "Curso seleccionado",
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 15),
                  fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10.0),
          TextField(
              readOnly: true,
              controller: _dataOneController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
              )
          ),
          const SizedBox(height: 10.0),
          // Muestra el ORE asignado, si está definido.
          if (widget.dataTwo != null) ... [
            Text(
              "ORE asigando",
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 15),
                  fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10.0),
          TextField(
              readOnly: true,
              controller: _dataTwoController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
          ),),
          const SizedBox(height: 10.0), ],
          // Muestra el Sare asignado, si está definido.
          if (widget.dataThree != null) ... [
            Text(
              "Sare asigando",
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 15),
                  fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10.0),
          TextField(
              readOnly: true,
              controller: _dataThreeController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.hintColor),
                      borderRadius: BorderRadius.circular(10.0)),
              )),
          ]
        ],
      ),
      actions: [
        Center(
          child: 
          //Uso del componente ´ActionsFormCheck´ para la vista de las acciones
          ActionsFormCheck(isEditing: true,
          onUpdate: () async {
            try {
              // Ejecuta la acción de aceptación y muestra un mensaje de éxito.
              widget.accept();
              if (context.mounted) {
                showCustomSnackBar(
                    context, widget.messageSuccess, greenColor);
              }
            } catch (e) {
              // Muestra un mensaje de error en caso de que ocurra una excepción.
              if (context.mounted) {
                showCustomSnackBar(context, "Error: $e", Colors.red);
              }
            }
            Navigator.pop(context);
          },
          // Acción al presionar "Cancelar".
          onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}