import 'package:flutter/cupertino.dart';

class AsignCupoLogic {
  final TextEditingController textController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController cupoController = TextEditingController();

  void dispose() {
    textController.dispose();
    idController.dispose();
    cupoController.dispose();
  }



}