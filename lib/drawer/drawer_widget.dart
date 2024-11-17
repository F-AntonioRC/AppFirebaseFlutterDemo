import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_event.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/dataConst/constand.dart';

class _NavigationItem {
  final NavItem item;
  final String title;
  final Icon icon;

  _NavigationItem(
      {required this.item, required this.title, required this.icon});
}

class NavDrawerWidget extends StatefulWidget {
  final String? userEmail;

  const NavDrawerWidget({super.key, this.userEmail});

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  // Items del Drawer
  final List<_NavigationItem> _drawerItems = [
    _NavigationItem(
        item: NavItem.homeView,
        title: "Home",
        icon: const Icon(CupertinoIcons.house_fill)),
    _NavigationItem(
        item: NavItem.employeeView,
        title: "Employee",
        icon: const Icon(
          CupertinoIcons.person_3_fill,
        )),
    _NavigationItem(
        item: NavItem.courseView,
        title: "Courses",
        icon: const Icon(
          CupertinoIcons.collections_solid,
        )),
    _NavigationItem(
        item: NavItem.emailView,
        title: "Email",
        icon: const Icon(CupertinoIcons.mail_solid)),
    _NavigationItem(
        item: NavItem.documentView,
        title: "SendDocument",
        icon: const Icon(CupertinoIcons.doc_fill)),
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

  @override
  Widget build(BuildContext context) => Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Bienvenido',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            accountEmail: Text(widget.userEmail ?? 'No Email',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/backgroundProfile.jpeg'))),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpeg'),
            ),
          ),
          // Drawer items
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _drawerItems.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return BlocBuilder<NavDrawerBloc, NavDrawerState>(
                  buildWhen: (previous, current) =>
                      previous.selectedItem != current.selectedItem,
                  builder: (context, state) =>
                      _buildDrawerItem(_drawerItems[i], state),
                );
              }),
        ],
      ));

  Widget _buildDrawerItem(_NavigationItem data, NavDrawerState state) {
    return ListTile(
      title: Text(
        data.title,
        style: TextStyle(
          fontWeight: data.item == state.selectedItem
              ? FontWeight.bold
              : FontWeight.w400,
          color:
              data.item == state.selectedItem ? darkBackground : Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      leading: data.icon,
      onTap: () {
        // Actualiza el estado del Bloc cuando se selecciona un ítem
        BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(data.item));

        // En pantallas pequeñas, cierra el Drawer
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    );
  }
}
