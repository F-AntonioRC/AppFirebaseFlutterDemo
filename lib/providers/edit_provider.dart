import 'package:flutter/material.dart';

class EditProvider extends ChangeNotifier {
  Map<String, dynamic>? _data;

  Map<String, dynamic>? get data => _data;

  void setData(Map<String, dynamic> editData) {
    _data = editData;
    notifyListeners();
  }

  // Actualiza solo los campos que necesitas, reutilizable para diferentes tipos de datos
  void updateData(Map<String, dynamic> updatedData) {
    if (_data != null) {
      _data!.addAll(updatedData); // Puedes fusionar los datos actuales con los nuevos
      notifyListeners();
    }
  }

  void clearData() {
    _data = null;
    notifyListeners();
  }

  void refreshData() {
    notifyListeners();
  }
}
