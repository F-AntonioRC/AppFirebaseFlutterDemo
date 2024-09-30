
import 'package:bloc/bloc.dart';
import 'package:testwithfirebase/bloc/drawer_event.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc() : super(const NavDrawerState(NavItem.homeView)) {
    on<NavigateTo>(
          (event, emit) {
        if (event.destination != state.selectedItem) {
          emit(NavDrawerState(event.destination));
        }
      },
    );
  }
}