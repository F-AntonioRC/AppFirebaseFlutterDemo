import 'package:bloc/bloc.dart';
import 'package:testwithfirebase/bloc/drawer_event.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';

  /// La clase `NavDrawerBloc` que extiende de Bloc es el encargado de gestionar la navegación a
  /// través del menú lateral.
  ///
  /// Este [NavDrawerBloc] escucha eventos relacionados con la navegación (por ejemplo,
  /// [NavigateTo]) y actualiza el estado del menú lateral ([NavDrawerState]) en consecuencia.
class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {

  /// Constructor del [NavDrawerBloc].
  ///
  /// Inicializa el estado con la vista de inicio ([NavItem.homeView]) y configura
  /// el manejo de eventos. En particular, cuando se recibe un evento [NavigateTo],
  /// se comprueba si el destino del evento es diferente al elemento actualmente
  /// seleccionado. Si es diferente, se emite un nuevo estado con el destino actualizado.

  NavDrawerBloc() : super(const NavDrawerState(NavItem.homeView)) {
    on<NavigateTo>(
          (event, emit) {
            // Condición que verifica si el destino solicitado es distinto al actual
        if (event.destination != state.selectedItem) {
          emit(NavDrawerState(event.destination)); // Emite un nuevo estado con el destino del evento
        }
      },
    );
  }
}