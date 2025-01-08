import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';

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