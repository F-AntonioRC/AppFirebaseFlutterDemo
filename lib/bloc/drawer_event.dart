import 'package:equatable/equatable.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';

sealed class NavDrawerEvent extends Equatable {
  const NavDrawerEvent();
}

class NavigateTo extends NavDrawerEvent {
  final NavItem destination;

  const NavigateTo(this.destination);

  @override
  List<Object?> get props => [
    destination,
  ];
}