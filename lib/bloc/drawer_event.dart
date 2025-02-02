import 'package:equatable/equatable.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';

/// La clase `NavDrawerEvent` es la base para los eventos del menú lateral (Navigation Drawer).
///
/// Se declara como `sealed` para restringir las clases que pueden heredar de ella,
/// lo que ayuda a controlar la jerarquía de eventos. Además, extiende de [Equatable]
/// para facilitar la comparación de instancias en tests y para otras operaciones donde
/// la igualdad basada en el valor es importante.

sealed class NavDrawerEvent extends Equatable {
  const NavDrawerEvent(); // Constructor constante para permitir la creación de instancias inmutables.
}

  /// Evento que indica la navegación hacia un destino específico dentro del menú lateral.
  ///
  /// Al heredar de [NavDrawerEvent], este evento se puede utilizar en estructuras
  /// de control de flujo o en sistemas de manejo de estado que reaccionen a eventos
  /// relacionados con la navegación.

class NavigateTo extends NavDrawerEvent {
  /// Este campo almacena el elemento del menú (de tipo [NavItem]) que representa
  /// la pantalla o sección de la aplicación a la que se debe navegar.
  final NavItem destination; // Destino al que se desea navegar.

  /// Constructor constante que inicializa el evento con el destino especificado.
  const NavigateTo(this.destination);

  //Lista de objetos con el destino
  @override
  List<Object?> get props => [
    destination,
  ];
}