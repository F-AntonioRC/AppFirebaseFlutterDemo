import 'package:flutter/cupertino.dart';
import '../../components/firebase_dropdown.dart';

class EmployeeController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  String? sexDropdownValue;
  final FirebaseDropdownController areaController = FirebaseDropdownController();
  final FirebaseDropdownController sareController = FirebaseDropdownController();

  EmployeeController(Map<String, dynamic>? initialData) {
    if (initialData != null) {
      nameController.text = initialData['Nombre'] ?? '';
      sexDropdownValue = initialData['Sexo'];
      areaController.setDocument({'NombreArea': initialData['Area']});
      sareController.setDocument({'sare': initialData['Sare']});
    }
  }

  void updateSex(String? newValue) {
    sexDropdownValue = newValue;
    notifyListeners();
  }

  void resetForm() {
    nameController.clear();
    sexDropdownValue = null;
    areaController.clearSelection();
    sareController.clearSelection();
    notifyListeners();
  }
}
