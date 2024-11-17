import 'package:equatable/equatable.dart';

enum NavItemNormal {
  homeUserView,
  cursosView,
  configuracionUserView,
  cerrarSesionView
}

class NavDrawerStateNormal extends Equatable {
  final NavItemNormal selected;

  const NavDrawerStateNormal(this.selected);

  @override
  List<Object?> get props => [
    selected
  ];
}