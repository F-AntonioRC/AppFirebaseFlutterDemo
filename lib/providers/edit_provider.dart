import 'package:flutter/material.dart';

  /// Proveedor que gestiona los datos de edición.
  ///
  /// La clase [EditProvider] extiende de [ChangeNotifier] y permite almacenar,
  /// actualizar y limpiar un conjunto de datos (en forma de mapa) que pueden ser
  /// utilizados por diferentes widgets para mostrar o modificar información en la UI.
  /// Cada vez que se modifica el dato, se notifica a los listeners para que actualicen
  /// la interfaz de forma reactiva.

class EditProvider extends ChangeNotifier {
  // Variable privada que almacena los datos de edición.
  Map<String, dynamic>? _data;

  // Retorna los datos de edición actualmente almacenados.
  Map<String, dynamic>? get data => _data;

  /// Asigna nuevos datos de edición y notifica a los listeners.
  ///
  /// [editData]: Mapa con los datos que se quieren establecer para la edición.
  void setData(Map<String, dynamic> editData) {
    _data = editData;
    notifyListeners();
  }

  /// Actualiza solo los campos necesarios dentro de los datos de edición actuales.
  ///
  /// Este metodo fusiona los datos existentes con los nuevos datos proporcionados en [updatedData]
  /// mediante el metodo [addAll] del mapa y notifica a los listeners para que actualicen la UI.
  void updateData(Map<String, dynamic> updatedData) {
    if (_data != null) {
      _data!.addAll(updatedData);
      notifyListeners();
    }
  }

  /// Limpia los datos de edición, estableciéndolos en null, y notifica a los listeners.
  void clearData() {
    _data = null;
    notifyListeners();
  }

  /// Notifica a los listeners sin modificar los datos.
  ///
  /// Este metodo se puede utilizar para forzar una actualización de la UI cuando los datos
  /// hayan sido modificados de forma externa o se requiera refrescar la vista.
  void refreshData() {
    notifyListeners();
  }
}
