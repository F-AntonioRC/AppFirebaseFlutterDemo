import 'package:equatable/equatable.dart';

/// Enumeración que define los elementos o vistas disponibles en el menú lateral.
///
/// Cada valor del enum [NavItem] representa una sección o funcionalidad
/// específica de la aplicación.

enum NavItem {
  homeView, //Vista del dashboard
  employeeView, //Vista de los empleados
  courseView, //Vista de los cursos
  emailView, //Vista para asignar cursos
  documentView, //Vista de los documentos
  usersView,
  configuration, //Vista de la configuración
  logout //Vista para cerrar sesión
}

/// La Clase `NavDrawerState` que representa el estado del menú lateral (Navigation Drawer).
///
/// Este estado contiene el elemento seleccionado actualmente, lo cual es útil
/// para determinar qué vista debe mostrarse o resaltar en la interfaz de usuario.

class NavDrawerState extends Equatable {
  final NavItem selectedItem; // Elemento del menú lateral actualmente seleccionado.

  // Constructor constante que inicializa el estado con el elemento seleccionado.
  const NavDrawerState(this.selectedItem);

  //Lista de los objetos para el item seleccionado
  @override
  List<Object?> get props => [
    selectedItem,
  ];
}