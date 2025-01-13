import 'package:flutter/cupertino.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';

class AsignCupoLogic {
  final TextEditingController textController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final FirebaseDropdownController cupoController = FirebaseDropdownController();

  void dispose() {
    textController.dispose();
    idController.dispose();
    cupoController.clearSelection();
  }



}