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
import 'package:testwithfirebase/pages/notification_icon_widget.dart';

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
  // Servicio de autenticación para obtener datos del usuario.
  late AuthService authService;

  // Bloc que gestiona el estado del Drawer y la navegación.
  late NavDrawerBloc _bloc;

  // Widget que contiene el contenido actual que se mostrará según la opción del Drawer.
  late Widget _content;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    _bloc = NavDrawerBloc();
    // Se inicializa el contenido en función de la opción seleccionada en el Drawer.
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el correo del usuario actual para pasarlo al Drawer.
    String? userEmail = authService.getCurrentUserEmail();

    return BlocProvider(
      // Se provee el NavDrawerBloc para que el resto de la interfaz pueda reaccionar
      // a los cambios en la navegación.
      create: (context) => _bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        // Escucha cambios en el estado del Drawer y actualiza el contenido correspondiente.
        listener: (BuildContext context, NavDrawerState state) {
          setState(() {
            _content = _getContentForState(state.selectedItem);
          });
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Se determina si se trata de una pantalla grande (ancho > 800)
              // para decidir si se muestra el Drawer de forma permanente.
              bool isLargeScreen = constraints.maxWidth > 800;
              return Scaffold(
                appBar: AppBar(
                  // El título del AppBar varía según la opción seleccionada.
                  title: Text(
                    _getAppbarTitle(state.selectedItem),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  shadowColor: Colors.black ,
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  actions: const [
                    // Widget que muestra un ícono de notificaciones.
                    NotificationIconWidget()
                  ],
                ),
                // En pantallas pequeñas se muestra el Drawer como menú lateral.
                drawer: isLargeScreen ? null : NavDrawerWidget(userEmail: userEmail),
                body: Row(
                  children: [
                    // En pantallas grandes se muestra el Drawer en forma permanente.
                    if (isLargeScreen)
                      SizedBox(
                        width: 300, // Ancho fijo para el Drawer en pantallas grandes.
                        child: NavDrawerWidget(userEmail: userEmail),
                      ),
                    // Área que muestra el contenido actual basado en la navegación.
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

  /// Retorna el contenido correspondiente en función del [selectedItem] del Drawer.
  ///
  /// Este metodo determina qué widget se debe mostrar en la pantalla principal
  /// según la opción seleccionada en el menú lateral.

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

  /// Retorna el título que se debe mostrar en el AppBar en función del [selectedItem].
  ///
  /// Este metodo asocia cada opción del Drawer con un título específico.

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
