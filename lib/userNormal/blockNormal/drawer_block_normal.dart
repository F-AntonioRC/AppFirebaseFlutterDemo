import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_event_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';

/// La clase `NavDrawerBloc` que extiende de Bloc es el encargado de gestionar la navegación a
/// través del menú lateral.
///
/// Este [NavDrawerBlocNormal] escucha eventos relacionados con la navegación (por ejemplo,
/// [NavigationNormalTo]) y actualiza el estado del menú lateral ([NavDrawerStateNormal]) en consecuencia.
class NavDrawerBlocNormal extends Bloc<NavDrawerEventNormal, NavDrawerStateNormal> {

  /// Constructor del [NavDrawerBlocNormal].
  ///
  /// Inicializa el estado con la vista de inicio ([NavItemNormal.homeUserView]) y configura
  /// el manejo de eventos. En particular, cuando se recibe un evento [NavigationNormalTo],
  /// se comprueba si el destino del evento es diferente al elemento actualmente
  /// seleccionado. Si es diferente, se emite un nuevo estado con el destino actualizado.

  NavDrawerBlocNormal() : super(const NavDrawerStateNormal(NavItemNormal.homeUserView)) {
    on<NavigationNormalTo>(
        (event, emit) {
          // Condición que verifica si el destino solicitado es distinto al actual
          if(event.destination != state.selected) {
            emit(NavDrawerStateNormal(event.destination)); // Emite un nuevo estado con el destino del evento
          }
        }
    );
  }
}