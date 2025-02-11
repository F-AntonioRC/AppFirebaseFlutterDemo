import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/build_field.dart';
import 'package:testwithfirebase/components/formPatrts/ink_component.dart';
import 'package:testwithfirebase/components/sendEmail/body_card_detailCourse.dart';
import 'package:testwithfirebase/service/detailCourseService/service_send_email.dart';
import '../../dataConst/constand.dart';
import '../../util/responsive.dart';
import '../formPatrts/custom_snackbar.dart';

/// Este widget muestra un cuadro de diálogo para gestionar el envío de correos electrónicos
/// relacionados con un curso.
class DialogEmail extends StatefulWidget {
  final String nameCourse; //Parametro obligatorio, representa el nombre del curso seleccionado.
  final String dateInit; //Parametro obligatorio, la fecha de inicio del curso.
  final String dateRegister; //Valor obligatorio, la fecha de registro del curso.
  final String sendDocument; //Valor obligatorio, la fecha de envío del documento.
  final String? nameOre; //Valor opcional, el nombre del ORE asignado.
  final String? nameSare; //Valor opcional, el nombre del SARE asignado.
  final String? idOre; //Valor opcional, el Id del ORE.
  final String? idSare; //Valor opcional, el Id del Sare.

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
  // Controladores para los campos del diálogo
  late final TextEditingController _nameCourseController;
  late final TextEditingController _dateInitController;
  late final TextEditingController _dateRegisterController;
  late final TextEditingController _dateSendEmailController;
  final TextEditingController _nameOreController = TextEditingController();
  final TextEditingController _nameSareController = TextEditingController();
  TextEditingController bodyEmailController = TextEditingController();

    /// Limpieza de recursos: Libera los controladores para evitar fugas de memoria.
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

  /// Inicialización de los controladores para los campos de texto
  /// Los valores iniciales de los controladores se asignan desde las propiedades 
  /// `nameCourse`, `dateInit`, `dateRegister`, `sendDocument`, `nameOre` y `nameSare`.
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

  /// Construcción del widget principal.
  /// Muestra un `AlertDialog` con los detalles del curso asignado y un campo para crear el correo.
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
          BodyCardDetailCourse(
            firstController: _nameCourseController,
            firstTitle: "Curso seleccionado",
            firstIcon: const Icon(Icons.account_box),
            secondController: _dateInitController,
            secondTitle: "Fecha de inicio",
            secondIcon: const Icon(Icons.date_range),
          ),
          const SizedBox(height: 10.0),
          BodyCardDetailCourse(
              firstController: _dateRegisterController,
              firstTitle: "Registro",
              firstIcon: const Icon(Icons.event),
              secondController: _dateSendEmailController,
              secondTitle: "Envio constancia",
              secondIcon: const Icon(Icons.event_available_sharp)),
          const SizedBox(height: 10.0),
          // Muestra el Ore asignado, si está definido.
          if (widget.nameOre != 'N/A') ...[
            BuildField(
                title: 'ORE Asignado',
                controller: _nameOreController,
                theme: theme),
          ],
          // Muestra el Sare asignado, si está definido.
          if (widget.nameSare != 'N/A') ...[
            BuildField(
                title: 'SARE Asignado',
                controller: _nameSareController,
                theme: theme),
          ],
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  "Escribe el mensaje",
                  style: TextStyle(
                      fontSize: responsiveFontSize(context, 15),
                      fontWeight: FontWeight.bold),
                ),
              ),
               // Botón para copiar correos al portapapeles
              Expanded(
                  flex: 1,
                  child: InkComponent(
                      tooltip: 'Copiar Correos',
                      iconInk: const Icon(
                        Icons.copy,
                        color: Colors.black,
                      ),
                      inkFunction: () async {
                        try {
                          await copyEmail(context, widget.idOre, widget.idSare);
                          if (context.mounted) {
                            showCustomSnackBar(context,
                                "Correos copiados al portapapeles", greenColorLight);
                          }
                        } catch (e, stacktrace) {
                          if (context.mounted) {
                            showCustomSnackBar(
                                context, "Error: $e", Colors.red);
                          }
                          Sentry.captureException(e,
                          stackTrace: stacktrace,
                          withScope: (scope) {
                            scope.setTag('Error_Widget_DialogEmail_copyEmail', 'Error en Id Sare u Ore');
                          });
                        }
                      })),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            child: TextField(
              controller: bodyEmailController,
              maxLines: 3,
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
          //Uso del componente ´ActionsFormCheck´ para la vista de las acciones
          child: ActionsFormCheck(
            isEditing: true,
            onUpdate: () async {
              try {
                // Ejecuta el metodo para enviar un correo con los datos proporcionados y muestra un 
                //mensaje de éxito con manejo de excepciones.
                await sendEmail(
                    context,
                    bodyEmailController,
                    widget.nameCourse,
                    widget.dateInit,
                    widget.dateRegister,
                    widget.sendDocument,
                    widget.idOre,
                    widget.idSare);
                if (context.mounted) {
                  showCustomSnackBar(
                      context, "Email generado con exito", greenColorLight);
                  Navigator.pop(context);
                }
              } catch (e, stacktrace) {
                if (context.mounted) {
                  showCustomSnackBar(context, "Error: $e", Colors.red);
                }
                Sentry.captureException(e,
                stackTrace: stacktrace,
                withScope: (scope) {
                  scope.setTag('Error_Widget_DialogEmail_sendEmail', 'Error en Id Sare u Ore');
                }
                );
              }
            },
            // Acción al presionar "Cancelar".
            onCancel: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
