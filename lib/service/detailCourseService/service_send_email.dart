import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/detailCourseService/send_email_methods.dart';
import '../../components/custom_snackbar.dart';

Future<void> sendEmail(
    BuildContext context,
    TextEditingController bodyEmailController,
    String nameCourse,
    String dateInit,
    String dateRegister,
    String sendDocument,
    String? nameArea,
    String? nameSare,
    String? idOre,
    String? idSare) async {
  if (idOre != null && idOre != 'N/A') {
    try {
      await SendEmailMethods().sendEmailToOre(idOre, nameCourse, dateInit,
          dateRegister, sendDocument, bodyEmailController.text.trim());
      if (context.mounted) {
        showCustomSnackBar(context, "Email generado con exito", greenColor);
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, "Error: $e", Colors.red);
      }
    }
  } else if (idSare != null && idSare != 'N/A') {
    try {
      await SendEmailMethods().sendEmailToSare(idSare, nameCourse, dateInit,
          dateRegister, sendDocument, bodyEmailController.text.trim());
      if (context.mounted) {
        showCustomSnackBar(context, "Email generado con exito", greenColor);
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, 'Error: $e', Colors.red);
      }
    }
  } else {
    if (context.mounted) {
      showCustomSnackBar(
          context, 'No se encontro Area o sare asignado', Colors.red);
    }
  }
}
