import 'package:equatable/equatable.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';

sealed class NavDrawerEventNormal extends Equatable {
  const NavDrawerEventNormal();
}

class NavigationNormalTo extends NavDrawerEventNormal {
  final NavItemNormal destination;

  const NavigationNormalTo(this.destination);

  @override
  List<Object?> get props => [
    destination,
  ];
}