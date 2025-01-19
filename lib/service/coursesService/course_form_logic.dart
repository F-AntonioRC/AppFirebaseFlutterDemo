import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

class CourseFormLogic {
  final List<String> dropdowntrimestre = [
    '1',
    '2',
    '3',
    '4'
  ];
  String? trimestreValue;
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController nomenclaturaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController registroController = TextEditingController();
  TextEditingController envioConstanciaController = TextEditingController();
  FirebaseDropdownController controllerDependency = FirebaseDropdownController();

  bool isClearing = false;

  void clearControllers() {
    nameCourseController.clear();
    nomenclaturaController.clear();
    trimestreValue = null;
    dateController.clear();
    registroController.clear();
    envioConstanciaController.clear();
    controllerDependency.clearSelection();
  }

  /// Limpia los datos del proveedor
  void clearProviderData(BuildContext context) {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  /// Actualizar la vista
  void refreshProviderData(BuildContext context) {
    final provier = Provider.of<EditProvider>(context, listen: false);
    provier.refreshData();
  }

  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;
    if (provider.data != null) {
      nameCourseController.text = provider.data?['NombreCurso'];
      nomenclaturaController.text = provider.data?['NomenclaturaCurso'];
      trimestreValue = provider.data?['Trimestre'];
      dateController.text = provider.data?['FechaInicioCurso'];
      registroController.text = provider.data?['FechaRegistro'];
      envioConstanciaController.text = provider.data?['FechaEnvioConstancia'];
      if (provider.data?['Dependencia'] != null) {
        controllerDependency.setDocument({
          'Id': provider.data?['IdDependencia'],
          'Dependencia': provider.data?['Dependencia']
        });
      }
    }
  }

}
