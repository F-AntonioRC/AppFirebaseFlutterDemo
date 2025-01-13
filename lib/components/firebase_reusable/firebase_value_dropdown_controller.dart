import 'package:flutter/cupertino.dart';

class FirebaseValueDropdownController extends ValueNotifier<String?>{
  FirebaseValueDropdownController([String? initialValue]) : super(initialValue);

  String? get selectedValue => value;

  void setValue(String? value) {
    this.value = value;
  }

  void initialize(String? value) {
    this.value = value;
  }

  void clearDocument() {
    value = null;
  }
}