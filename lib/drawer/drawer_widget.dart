import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_event.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

  /// La clase privada `_NavigationItem` representa un ítem de navegación en el Drawer.
  ///
  /// Cada objeto de [_NavigationItem] contiene:
  /// - [item]: Valor del enum [NavItem] que identifica la vista o funcionalidad.
  /// - [title]: Texto que se mostrará como título en el Drawer.
  /// - [icon]: Ícono asociado a la opción del Drawer.

class _NavigationItem {
  final NavItem item;
  final String title;
  final Icon icon;

  _NavigationItem(
      {required this.item, required this.title, required this.icon});
}

  /// Widget que representa el menú lateral (Drawer) de la aplicación.
  ///
  /// Este widget muestra la información del usuario (nombre y correo) y una lista
  /// de opciones de navegación. Al seleccionar una opción, se actualiza el estado del
  /// Bloc [NavDrawerBloc] y, en dispositivos con pantallas pequeñas, se cierra el Drawer.

  class NavDrawerWidget extends StatefulWidget {
  final String? userEmail; // Correo electrónico del usuario que se mostrará en el header del Drawer.

  /// Constructor del [NavDrawerWidget].
  const NavDrawerWidget({super.key, this.userEmail});

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

  /// Estado asociado al [NavDrawerWidget] que construye y gestiona la interfaz del Drawer.
  class _NavDrawerWidgetState extends State<NavDrawerWidget> {
    // Lista de ítems que se mostrarán en el Drawer.
  final List<_NavigationItem> _drawerItems = [
    _NavigationItem(
        item: NavItem.homeView,
        title: "Home",
        icon: const Icon(Icons.home)),
    _NavigationItem(
        item: NavItem.employeeView,
        title: "Empleados",
        icon: const Icon(
          Icons.people_alt_rounded,
        )),
    _NavigationItem(
        item: NavItem.courseView,
        title: "Cursos",
        icon: const Icon(
          Icons.folder_copy,
        )),
    _NavigationItem(
        item: NavItem.emailView,
        title: "Asignar Cursos",
        icon: const Icon(Icons.contact_mail_rounded)),
    _NavigationItem(
        item: NavItem.documentView,
        title: "Documentos",
        icon: const Icon(Icons.article_rounded)),
    _NavigationItem(
        item: NavItem.configuration,
        title: "Configuración",
        icon: const Icon(
          Icons.settings,
        )),
    _NavigationItem(
        item: NavItem.logout,
        title: "Cerrar Sesion",
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        )),
  ];

  //Contrucción del Widget donde se mostraran los elementos del _drawerItems
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
                    image: AssetImage('assets/images/logo.jpg'))),
            currentAccountPicture: const CircleAvatar(
              radius: 2,
              backgroundImage: AssetImage('assets/images/logoIcon.jpg'),
            ),
          ),
          // Drawer items
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _drawerItems.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                // Utiliza BlocBuilder para reconstruir solo el ítem que cambie de estado.
                return BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  buildWhen: (previous, current) =>
                      previous.selectedItem != current.selectedItem,
                  builder: (context, state) =>
                      _buildDrawerItem(_drawerItems[i], state),
                );
              }),
        ],
      ));

  /// Construye cada uno de los ítems del Drawer.
  ///
  /// [data] contiene la información del ítem (título, icono y el enum [NavItem]).
  /// [state] es el estado actual del Bloc, el cual se utiliza para determinar si el
  /// ítem está seleccionado.
  ///
  /// Devuelve un [ListTile] que, al ser presionado, actualiza el estado del Bloc y
  /// cierra el Drawer en dispositivos con pantallas pequeñas.

  Widget _buildDrawerItem(_NavigationItem data, NavDrawerState state) {
    return ListTile(
      title: Text(
        data.title,
        style: TextStyle(
          // Resalta el texto si el ítem es el seleccionado
          fontWeight: data.item == state.selectedItem
              ? FontWeight.bold
              : FontWeight.w400,
          // Cambia el color del texto si el ítem es el seleccionado.
          color: data.item == state.selectedItem
              ? darkBackground
              : Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      leading: data.icon,
      onTap: () {
        // Actualiza el estado del Bloc cuando se selecciona un ítem
        BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(data.item));
        // Si es posible volver atrás (por ejemplo, en pantallas pequeñas), cierra el Drawer.
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    );
  }
}
