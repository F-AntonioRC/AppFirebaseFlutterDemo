import 'package:flutter/cupertino.dart';

  /// La clase `FirebaseValueDropdownController` controlador personalizado para gestionar la
  /// selección en un `DropdownButtonFormField` basado en valores obtenidos desde Firebase.
  ///
  /// Esta clase extiende `ValueNotifier<String?>`, lo que permite que los widgets
  /// que la utilicen escuchen cambios en el valor seleccionado y se actualicen automáticamente.
class FirebaseValueDropdownController extends ValueNotifier<String?>{

  /// Constructor que inicializa el controlador con un valor inicial opcional.
  ///
  /// - [initialValue]: El valor inicial del dropdown (puede ser `null` si no hay una selección previa).

  FirebaseValueDropdownController(super.initialValue);

  /// Obtiene el valor seleccionado actualmente en el dropdown.
  String? get selectedValue => value;

  /// Establece un nuevo valor seleccionado y notifica a los listeners del cambio.
  ///
  /// - [value]: El nuevo valor seleccionado.
  void setValue(String? value) {
    this.value = value;
  }

  /// Inicializa el controlador con un valor específico sin notificar cambios.
  /// - [value]: El valor con el que se debe inicializar el dropdown.
  void initialize(String? value) {
    this.value = value;
  }

  /// Borra la selección actual, estableciendo el valor en `null` y notificando a los listeners.
  void clearDocument() {
    value = null;
  }
}