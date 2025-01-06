class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "El correo no puede estar vacío";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Ingresa un correo válido";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "La contraseña no puede estar vacía";
    }
    return null;
  }
}