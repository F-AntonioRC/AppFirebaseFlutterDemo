import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_event_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';

class NavDrawerBlocNormal extends Bloc<NavDrawerEventNormal, NavDrawerStateNormal> {
  NavDrawerBlocNormal() : super(const NavDrawerStateNormal(NavItemNormal.homeUserView)) {
    on<NavigationNormalTo>(
        (event, emit) {
          if(event.destination != state.selected) {
            emit(NavDrawerStateNormal(event.destination));
          }
        }
    );
  }
}