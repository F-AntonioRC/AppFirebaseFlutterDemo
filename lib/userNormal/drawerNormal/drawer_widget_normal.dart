import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_block_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_event_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';
import '../../../dataConst/constand.dart';

/// La clase privada `_NavigationItemNormal` representa un ítem de navegación en el Drawer.
///
/// Cada objeto de [_NavigationItemNormal] contiene:
/// - [item]: Valor del enum [NavItemNormal] que identifica la vista o funcionalidad.
/// - [title]: Texto que se mostrará como título en el Drawer.
/// - [icon]: Ícono asociado a la opción del Drawer.

class _NavigationItemNormal {
  final NavItemNormal itemNormal;
  final String titleNormal;
  final Icon icon;

  _NavigationItemNormal(
      {required this.itemNormal,
      required this.titleNormal,
      required this.icon});
}

/// Widget que representa el menú lateral (Drawer) de la aplicación.
///
/// Este widget muestra la información del usuario (nombre y correo) y una lista
/// de opciones de navegación. Al seleccionar una opción, se actualiza el estado del
/// Bloc [NavDrawerBlocNormal] y, en dispositivos con pantallas pequeñas, se cierra el Drawer.

class NavDrawerWidgetNormal extends StatefulWidget {
  final String? userEmail; // Correo electrónico del usuario que se mostrará en el header del Drawer

  /// Constructor del [NavDrawerWidgetNormal].
  const NavDrawerWidgetNormal({super.key, this.userEmail});

  @override
  State<NavDrawerWidgetNormal> createState() => _NavDrawerWidgetNormalState();
}

  /// Estado asociado al [NavDrawerWidgetNormal] que construye y gestiona la interfaz del Drawer.
class _NavDrawerWidgetNormalState extends State<NavDrawerWidgetNormal> {
  // Lista de ítems que se mostrarán en el Drawer.
  final List<_NavigationItemNormal> _drawerItemNormal = [
    _NavigationItemNormal(
        itemNormal: NavItemNormal.homeUserView,
        titleNormal: "Home",
        icon: const Icon(CupertinoIcons.house_fill)),
    _NavigationItemNormal(
        itemNormal: NavItemNormal.cursosView,
        titleNormal: "Mis Cursos",
        icon: const Icon(Icons.ballot)),
    _NavigationItemNormal(
        itemNormal: NavItemNormal.configuracionUserView,
        titleNormal: "Configuración",
        icon: const Icon(Icons.settings)),
    _NavigationItemNormal(
        itemNormal: NavItemNormal.cerrarSesionView,
        titleNormal: "Cerrar Sesión",
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.red,
        ))
  ];

  //Contrucción del Widget donde se mostraran los elementos del _NavDrawerWidgetNormalState
  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header del Drawer con información del usuario, se configuro para mostrar un texto
        // predeterminado junto con el correo del usuario e imagenes de decoración y de avatar
        // en la sesión.
        UserAccountsDrawerHeader(
            accountName: const Text(
              'Bienvenido',
              style: TextStyle(
                  color: darkBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ), accountEmail: Text(widget.userEmail ?? 'No Email',
            style: const TextStyle(
                color: dark, fontWeight: FontWeight.bold)),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/logoActualizado.jpg'))),
          currentAccountPicture: const CircleAvatar(
            radius: 2,
            backgroundImage: AssetImage('assets/images/logo.jpg'),
          ),
        ),
        // Drawer Items
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _drawerItemNormal.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              // Utiliza BlocBuilder para reconstruir solo el ítem que cambie de estado.
              return BlocBuilder<NavDrawerBlocNormal, NavDrawerStateNormal>
                ( buildWhen: (previous, current) =>
                  previous.selected != current.selected,
                  builder: (context, state) =>
                  _builderDrawerItemNormal(_drawerItemNormal[i], state)
              );
            })
      ],
    )
  );

  /// Construye cada uno de los ítems del Drawer.
  ///
  /// [data] contiene la información del ítem (título, icono y el enum [NavDrawerStateNormal]).
  /// [state] es el estado actual del Bloc, el cual se utiliza para determinar si el
  /// ítem está seleccionado.
  ///
  /// Devuelve un [ListTile] que, al ser presionado, actualiza el estado del Bloc y
  /// cierra el Drawer en dispositivos con pantallas pequeñas.

  Widget _builderDrawerItemNormal(_NavigationItemNormal data, NavDrawerStateNormal state){
    return ListTile(
      title: Text(
        data.titleNormal,
        style: TextStyle(
          // Resalta el texto si el ítem es el seleccionado
          fontWeight: data.itemNormal == state.selected
              ? FontWeight.bold
              : FontWeight.w400,
          // Cambia el color del texto si el ítem es el seleccionado.
          color: data.itemNormal == state.selected
              ? darkBackground
              : Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      leading: data.icon,
      onTap: () {
        // Actualiza el estado del Bloc cuando se selecciona un ítem
        BlocProvider.of<NavDrawerBlocNormal>(context).add(NavigationNormalTo(data.itemNormal));
        // Si es posible volver atrás (por ejemplo, en pantallas pequeñas), cierra el Drawer.
        if(Navigator.canPop(context)){
          Navigator.pop(context);
        }
      },
    );
  }

}
