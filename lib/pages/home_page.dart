import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/components/drawer_widget.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/pages/cerrar_sesion.dart';
import 'package:testwithfirebase/pages/configuration.dart';
import 'package:testwithfirebase/pages/dashboard_main.dart';
import 'package:testwithfirebase/pages/empoyee.dart';
import 'package:testwithfirebase/pages/pantalla_empleado.dart';
import 'package:testwithfirebase/pages/screen_cursos.dart';
import 'package:testwithfirebase/pages/send_document.dart';
import 'package:testwithfirebase/pages/send_email.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService authService;
  late NavDrawerBloc _bloc;
  late Widget _content;

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    _bloc = NavDrawerBloc();
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = authService.getCurrentUserEmail();

    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          setState(() {
            _content = _getContentForState(state.selectedItem);
          });
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isLargeScreen = constraints.maxWidth > 800;

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Employee()));
                  },
                  child: const Icon(Icons.person_add_alt_rounded),
                ),
                appBar: AppBar(
                  title: Text(
                    _getAppbarTitle(state.selectedItem),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: ligth,
                  shadowColor: Colors.black ,
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  actions: [
                    IconButton(
                      splashRadius: 35.0,
                      iconSize: 30.0,
                      tooltip: 'Salir',
                      icon: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.black,
                      ), onPressed: () {  },
                    ),
                  ],
                ),
                // Drawer se muestra dependiendo del tamaño de pantalla
                drawer: isLargeScreen ? null : NavDrawerWidget(userEmail: userEmail),
                body: Row(
                  children: [
                    if (isLargeScreen)
                      SizedBox(
                        width: 300, // Ancho del Drawer en pantallas grandes
                        child: NavDrawerWidget(userEmail: userEmail),
                      ),
                    Expanded(child: _content),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getContentForState(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeView:
        return const DashboardMain();
      case NavItem.employeeView:
        return const PantallaEmpleado();
      case NavItem.courseView:
        return const ScreenCursos();
      case NavItem.emailView:
        return const SendEmail();
      case NavItem.documentView:
        return const SendDocument();
      case NavItem.logout:
        return const CerrarSesion();
      case NavItem.configuration:
        return const Configuration();
      default:
        return const DashboardMain();
    }
  }

  String _getAppbarTitle(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeView:
        return "Home";
      case NavItem.employeeView:
        return "Empleados";
      case NavItem.courseView:
        return "Cursos";
      case NavItem.emailView:
        return "Correos";
      case NavItem.documentView:
        return "Documents";
      case NavItem.configuration:
        return "Configuración";
      case NavItem.logout:
        return "Cerrar Sesión";
      default:
        return "Navigation Drawer Demo";
    }
  }
}
