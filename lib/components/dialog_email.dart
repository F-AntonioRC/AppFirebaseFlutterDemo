import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/build_field.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/my_button.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/send_email_methods.dart';

import '../util/responsive.dart';

class DialogEmail extends StatefulWidget {
  final String nameCourse;
  final String dateInit;
  final String dateRegister;
  final String sendDocument;
  final String? nameArea;
  final String? nameSare;
  final String? idArea;
  final String? idSare;

  const DialogEmail({
    super.key,
    required this.nameCourse,
    required this.dateInit,
    required this.dateRegister,
    required this.sendDocument,
    this.nameArea,
    this.nameSare,
    this.idArea,
    this.idSare,
  });

  @override
  State<DialogEmail> createState() => _DialogEmailState();
}

class _DialogEmailState extends State<DialogEmail> {
  late final TextEditingController _nameCourseController;
  late final TextEditingController _dateInitController;
  late final TextEditingController _dateRegisterController;
  late final TextEditingController _dateSendEmailController;
  late final TextEditingController _nameAreaController;
  late final TextEditingController _nameSareController;
  TextEditingController bodyEmailController = TextEditingController();

  @override
  void dispose() {
    _nameCourseController.dispose();
    _dateInitController.dispose();
    _dateRegisterController.dispose();
    _dateSendEmailController.dispose();
    _nameAreaController.dispose();
    _nameSareController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameCourseController = TextEditingController(text: widget.nameCourse);
    _dateInitController = TextEditingController(text: widget.dateInit);
    _dateRegisterController = TextEditingController(text: widget.dateRegister);
    _dateSendEmailController = TextEditingController(text: widget.sendDocument);
    _nameAreaController = TextEditingController(text: widget.nameArea);
    _nameSareController = TextEditingController(text: widget.nameSare);
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return AlertDialog(
      scrollable: true,
      title: const Text(
        "Enviar Correos",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(
                    "Curso seleccionado",
                    style: TextStyle(
                      fontSize: responsiveFontSize(context, 15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    enabled: false,
                    controller: _nameCourseController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box),
                      disabledBorder: _buildDisabledBorder(theme),
                      focusedBorder: _buildDisabledBorder(theme),
                    ),
                  ),
                ],
              ),),
              const SizedBox(width: 10.0),
              Expanded(child: Column(
                children: [
                  Text(
                    "Fecha de Inicio",
                    style: TextStyle(
                      fontSize: responsiveFontSize(context, 15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    enabled: false,
                    controller: _dateInitController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box),
                      disabledBorder: _buildDisabledBorder(theme),
                      focusedBorder: _buildDisabledBorder(theme),
                    ),
                  ),
                ],
              ))
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(
                    "Fecha termino",
                    style: TextStyle(
                      fontSize: responsiveFontSize(context, 15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    enabled: false,
                    controller: _dateRegisterController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box),
                      disabledBorder: _buildDisabledBorder(theme),
                      focusedBorder: _buildDisabledBorder(theme),
                    ),
                  ),
                ],
              )),
              const SizedBox(width: 10.0,),
              Expanded(child: Column(children: [
                Text(
                  "Envio Constancia",
                  style: TextStyle(
                    fontSize: responsiveFontSize(context, 15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  enabled: false,
                  controller: _dateSendEmailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box),
                    disabledBorder: _buildDisabledBorder(theme),
                    focusedBorder: _buildDisabledBorder(theme),
                  ),
                ),
              ],))
            ],
          ),
          const SizedBox(height: 10.0),
          if (widget.nameArea != null) ...[
            BuildField(title: 'Área Asignada', controller:  _nameAreaController, theme: theme),
          ],
          if (widget.nameSare != null) ...[
            BuildField(title: 'SARE', controller: _nameSareController, theme: theme),
          ],
          const SizedBox(height: 10.0),
          Text("Escribe el mensaje",
            style: TextStyle(fontSize: responsiveFontSize(context, 15), fontWeight: FontWeight.bold),),
          const SizedBox(height: 10.0,),
          SizedBox(
            width: 300,
            child: TextField(
              controller: bodyEmailController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Escribe tu mensaje',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              text: "Cancelar",
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => Navigator.pop(context),
              buttonColor: Colors.red,
            ),
            const SizedBox(width: 10.0),
            MyButton(text: "Generar",
              icon: const Icon(Icons.mark_email_read_rounded),
              buttonColor: greenColor,
              onPressed: () async {
              if(widget.idArea != null) {
                try{
                  await SendEmailMethods().sendEmailToArea(
                      widget.idArea!, widget.nameCourse, widget.dateInit, widget.dateRegister, widget.sendDocument, bodyEmailController.text);
                  if(context.mounted) {
                    showCustomSnackBar(context, "Email generado con exito", greenColor);
                  }
                } catch (e){
                  if(context.mounted) {
                    showCustomSnackBar(context, "Error: $e", Colors.red);
                  }
                }
              }
              },),
          ],
        )
      ],
    );
  }

  InputBorder _buildDisabledBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: theme.hintColor),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
