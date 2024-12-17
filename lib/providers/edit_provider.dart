import 'package:flutter/material.dart';

class EditProvider with ChangeNotifier {
  Map<String, dynamic>? _data;

  Map<String, dynamic>? get data => _data;

  void setData(Map<String, dynamic> editData) {
    _data = editData;
    notifyListeners();
  }

  void clearData() {
    _data = null;
    notifyListeners();
  }
}
