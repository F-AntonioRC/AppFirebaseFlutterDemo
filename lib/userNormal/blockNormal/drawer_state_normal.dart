import 'package:equatable/equatable.dart';

/// Enumeración que define los elementos o vistas disponibles en el menú lateral.
///
/// Cada valor del enum [NavItemNormal] representa una sección o funcionalidad
/// específica de la aplicación.

enum NavItemNormal {
  homeUserView, //Vista del dashboard del usuario normal
  cursosView, //Vista de cursos pendientes
  configuracionUserView, //Configuración del usuario normal
  cerrarSesionView //Vista para cerrar sesión
}

/// La Clase `NavDrawerStateNormal` que representa el estado del menú lateral (NavigationNormal Drawer).
///
/// Este estado contiene el elemento seleccionado actualmente, lo cual es útil
/// para determinar qué vista debe mostrarse o resaltar en la interfaz de usuario.

class NavDrawerStateNormal extends Equatable {
  final NavItemNormal selected; // Elemento del menú lateral actualmente seleccionado.

  // Constructor constante que inicializa el estado con el elemento seleccionado.
  const NavDrawerStateNormal(this.selected);

  //Lista de los objetos para el item seleccionado
  @override
  List<Object?> get props => [
    selected
  ];
}