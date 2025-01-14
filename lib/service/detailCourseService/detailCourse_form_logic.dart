import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../components/firebase_reusable/firebase_dropdown_controller.dart';
import '../../providers/edit_provider.dart';

class DetailCourseFormLogic {
  final FirebaseDropdownController controllerOre = FirebaseDropdownController();
  final FirebaseDropdownController controllerSare = FirebaseDropdownController();
  final FirebaseDropdownController controllerCourses = FirebaseDropdownController();

  bool isClearing = false;

  void clearControllers () {
    controllerOre.clearSelection();
    controllerSare.clearSelection();
    controllerCourses.clearSelection();
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

  /// Inicializa los controladores con datos del proveedor
  void initializeControllers(BuildContext context, EditProvider provider) {
    if (isClearing) return;

    if (provider.data != null) {

      if (provider.data?['IdOre'] != null) {
        controllerOre.setDocument({
          'Id': provider.data?['IdOre'],
          'Ore': provider.data?['Ore']
        });
      }
      if (provider.data?['IdCourse'] != null) {
        controllerCourses.setDocument({
          'Id': provider.data?['IdCourse'],
          'NameCourse': provider.data?['NameCourse']
        });
      }
      if (provider.data?['IdSare'] != null) {
        controllerSare.setDocument({
          'Id': provider.data?['IdSare'],
          'sare': provider.data?['sare']
        });
      }
    }
  }


}