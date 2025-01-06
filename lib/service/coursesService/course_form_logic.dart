import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/edit_provider.dart';

class CourseFormLogic {
  final List<String> dropdowntrimestre = [
    "1",
    "2",
    "3",
    "4"
  ];
  String? trimestreValue;
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController nomenclaturaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController registroController = TextEditingController();
  TextEditingController envioConstanciaController = TextEditingController();

  bool isClearing = false;

  void clearControllers() {
    nameCourseController.clear();
    nomenclaturaController.clear();
    trimestreValue = null;
    dateController.clear();
    registroController.clear();
    envioConstanciaController.clear();
  }

  /// Limpia los datos del proveedor
  void clearProviderData(BuildContext context) {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;
    if (provider.data != null) {
      nameCourseController.text = provider.data?['NameCourse'];
      nomenclaturaController.text = provider.data?['NomenclaturaCurso'];
      trimestreValue = provider.data?['Trimestre'];
      dateController.text = provider.data?['FechaInicioCurso'];
      registroController.text = provider.data?['Fecharegistro'];
      envioConstanciaController.text = provider.data?['FechaenvioConstancia'];
    }
  }

}
