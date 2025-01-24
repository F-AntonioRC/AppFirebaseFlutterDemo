import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/util/responsive.dart';
import '../../dataConst/constand.dart';
import '../formPatrts/custom_snackbar.dart';

class AssignCourseDialog extends StatefulWidget {
  final String? dataOne;
  final String? dataTwo;
  final String? dataThree;
  final VoidCallback accept;
  final String messageSuccess;

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
  late TextEditingController _dataOneController;

  late TextEditingController _dataTwoController;

  late TextEditingController _dataThreeController;
  @override
  void initState() {
    super.initState();
    // Inicializa el controlador con el valor de dataChange
    _dataOneController = TextEditingController(text: widget.dataOne);
    _dataTwoController = TextEditingController(text: widget.dataTwo);
    _dataThreeController = TextEditingController(text: widget.dataThree);
  }

  @override
  void dispose() {
    // Libera el controlador para evitar fugas de memoria
    _dataOneController.dispose();
    _dataTwoController.dispose();
    _dataThreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: const Text("¿Esta seguro que la selección en correcta?"),
      content: Column(
        children: [
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
          child: ActionsFormCheck(isEditing: true,
          onUpdate: () async {
            try {
              widget.accept();
              if (context.mounted) {
                showCustomSnackBar(
                    context, widget.messageSuccess, greenColor);
              }
            } catch (e) {
              if (context.mounted) {
                showCustomSnackBar(context, "Error: $e", Colors.red);
              }
            }
            Navigator.pop(context);
            //Navigator.of(context).pop();
          },
          onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}