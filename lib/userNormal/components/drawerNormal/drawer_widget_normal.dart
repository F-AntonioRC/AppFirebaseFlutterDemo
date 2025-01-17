import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_block_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_event_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';

import '../../../dataConst/constand.dart';

class _NavigationItemNormal {
  final NavItemNormal itemNormal;
  final String titleNormal;
  final Icon icon;

  _NavigationItemNormal(
      {required this.itemNormal,
      required this.titleNormal,
      required this.icon});
}

class NavDrawerWidgetNormal extends StatefulWidget {
  final String? userEmail;

  const NavDrawerWidgetNormal({super.key, this.userEmail});

  @override
  State<NavDrawerWidgetNormal> createState() => _NavDrawerWidgetNormalState();
}

class _NavDrawerWidgetNormalState extends State<NavDrawerWidgetNormal> {
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
            ), accountEmail: Text(widget.userEmail ?? 'No Email',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/logoActualizado.jpg'))),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.jpg'),
          ),
        ),
        // Drawer Items
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _drawerItemNormal.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return BlocBuilder<NavDrawerBlocNormal, NavDrawerStateNormal>
                ( buildWhen: (previous, current) =>
                  previous.selected != current,
                  builder: (context, state) =>
                  _builderDrawerItemNormal(_drawerItemNormal[i], state)
              );
            })
      ],
    )
  );

  Widget _builderDrawerItemNormal(_NavigationItemNormal data, NavDrawerStateNormal state){
    return ListTile(
      title: Text(
        data.titleNormal,
        style: TextStyle(
          fontWeight: data.itemNormal == state.selected
              ? FontWeight.bold
              : FontWeight.w400,
          color: data.itemNormal == state.selected
              ? darkBackground
              : Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      leading: data.icon,
      onTap: () {
        // Actualiza el estado del Bloc cuando se selecciona un ítem
        BlocProvider.of<NavDrawerBlocNormal>(context).add(NavigationNormalTo(data.itemNormal));

        // En pantallas pequeñas, cierra el Drawer
        if(Navigator.canPop(context)){
          Navigator.pop(context);
        }
      },
    );
  }

}
