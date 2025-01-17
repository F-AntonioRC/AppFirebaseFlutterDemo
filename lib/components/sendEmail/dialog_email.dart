import 'package:flutter/material.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/build_field.dart';
import 'package:testwithfirebase/components/sendEmail/body_card_detailCourse.dart';
import 'package:testwithfirebase/service/detailCourseService/service_send_email.dart';
import '../../util/responsive.dart';

class DialogEmail extends StatefulWidget {
  final String nameCourse;
  final String dateInit;
  final String dateRegister;
  final String sendDocument;
  final String? nameOre;
  final String? nameSare;
  final String? idOre;
  final String? idSare;

  const DialogEmail({
    super.key,
    required this.nameCourse,
    required this.dateInit,
    required this.dateRegister,
    required this.sendDocument,
    this.nameOre,
    this.nameSare,
    this.idOre,
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
  final TextEditingController _nameOreController = TextEditingController();
  final TextEditingController _nameSareController = TextEditingController();
  TextEditingController bodyEmailController = TextEditingController();

  @override
  void dispose() {
    _nameCourseController.dispose();
    _dateInitController.dispose();
    _dateRegisterController.dispose();
    _dateSendEmailController.dispose();
    _nameOreController.dispose();
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
    // Prellenar controladores si hay datos disponibles
    if (widget.nameOre != null && widget.nameOre != 'N/A') {
      _nameOreController.text = widget.nameOre!;
    } else {
      _nameOreController.text = 'No asignado';
    }
    if (widget.nameSare != null && widget.nameSare != 'N/A') {
      _nameSareController.text = widget.nameSare!;
    } else {
      _nameSareController.text = 'No Asignado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      scrollable: true,
      title: const Text(
        "Enviar Correos", style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        children: [
          BodyCardDetailCourse(
            firstController: _nameCourseController,
            firstTitle: "Curso seleccionado",
            firstIcon: const Icon(Icons.account_box),
            secondController: _dateInitController,
            secondTitle: "Fecha de inicio",
            secondIcon: const Icon(Icons.date_range),),
          const SizedBox(height: 10.0),
          BodyCardDetailCourse(
              firstController: _dateRegisterController,
              firstTitle: "Registro",
              firstIcon: const Icon(Icons.event),
              secondController: _dateSendEmailController,
              secondTitle: "Envio constancia",
              secondIcon: const Icon(Icons.event_available_sharp)),
          const SizedBox(height: 10.0),
          if (widget.nameOre != 'N/A') ...[
            BuildField(title: 'ORE Asignado',
                controller: _nameOreController,
                theme: theme),
          ],
          if (widget.nameSare != 'N/A') ...[
            BuildField(title: 'SARE Asignado',
                controller: _nameSareController,
                theme: theme),
          ],
          const SizedBox(height: 10.0),
          Text("Escribe el mensaje",
            style: TextStyle(fontSize: responsiveFontSize(context, 15),
                fontWeight: FontWeight.bold),),
          const SizedBox(height: 10.0,),
          SizedBox(
            width: 500,
            child: TextField(
              controller: bodyEmailController, maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Escribe tu mensaje',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          )
        ],
      ),
      actions: [
        Center(
          child: ActionsFormCheck(isEditing: true,
            onUpdate: () async {
              sendEmail(
                  context,
                  bodyEmailController,
                  widget.nameCourse,
                  widget.dateInit,
                  widget.dateRegister,
                  widget.sendDocument,
                  widget.nameOre,
                  widget.nameSare,
                  widget.idOre,
                  widget.idSare);
            },
            onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}