import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import '../../providers/edit_provider.dart';

class DetailCourseFormLogic {
  final FirebaseDropdownController controllerArea = FirebaseDropdownController();
  final FirebaseDropdownController controllerSare = FirebaseDropdownController();
  final FirebaseDropdownController controllerCourses = FirebaseDropdownController();

  bool isClearing = false;

  void clearControllers () {
    controllerArea.clearSelection();
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

      if (provider.data?['IdArea'] != null) {
        controllerArea.setDocument({
          'Id': provider.data?['IdArea'],
          'NombreArea': provider.data?['NombreArea']
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