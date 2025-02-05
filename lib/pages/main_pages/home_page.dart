import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/drawer/drawer_widget.dart';
import 'package:testwithfirebase/pages/configuration/cerrar_sesion.dart';
import 'package:testwithfirebase/pages/configuration/configuration.dart';
import 'package:testwithfirebase/pages/dashboard/dashboard_main.dart';
import 'package:testwithfirebase/pages/detailCourses/page_detail_courses.dart';
import 'package:testwithfirebase/pages/courses/screen_cursos.dart';
import 'package:testwithfirebase/pages/documents/trimesterview.dart';
import 'package:testwithfirebase/pages/employee/screen_employee.dart';
import 'package:testwithfirebase/pages/notification/notification_new.dart';

/// Pantalla principal de la aplicación.
///
/// Este widget es la página principal que organiza la navegación interna de la app
/// a través de un Drawer (menú lateral) y un AppBar. Dependiendo de la opción seleccionada
/// en el Drawer (representada por [NavItem]), se muestra el contenido correspondiente.
///
/// Se utiliza [BlocProvider] y [BlocConsumer] para gestionar el estado del Drawer a través
/// de [NavDrawerBloc] y actualizar la interfaz de forma reactiva.

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
                appBar: AppBar(
                  title: Text(
                    _getAppbarTitle(state.selectedItem),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  shadowColor: Colors.black ,
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                 actions: [
                    IconButton(
    icon: const Icon(Icons.notifications),
    tooltip: 'Notificaciones',
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => NotificationNew(), 
      );
    },
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
        return const ScreenEmployee();
      case NavItem.courseView:
        return const ScreenCursos();
      case NavItem.emailView:
        return const PageDetailCourses();
      case NavItem.documentView:
        return  const TrimesterView();//nuevo cambio en la vista 
      case NavItem.logout:
        return const CerrarSesion();
      case NavItem.configuration:
        return const Configuration();
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
        return "Asignar Cursos";
      case NavItem.documentView:
        return "Evidencia por Trimestre";
      case NavItem.configuration:
        return "Configuración";
      case NavItem.logout:
        return "Cerrar Sesión";
      }
  }
}
