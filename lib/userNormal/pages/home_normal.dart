import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/pages/configuration/cerrar_sesion.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_block_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';
import 'package:testwithfirebase/userNormal/pages/CourseSelectionPage.dart';
import 'package:testwithfirebase/userNormal/pages/UserNotificationsPage.dart';
import 'package:testwithfirebase/userNormal/pages/configuration_normal.dart';
import 'package:testwithfirebase/userNormal/pages/dashboard_normal.dart';

import '../drawerNormal/drawer_widget_normal.dart';

  /// Pantalla principal de la aplicación.
  ///
  /// Este widget es la página principal que organiza la navegación interna de la app
  /// a través de un Drawer (menú lateral) y un AppBar. Dependiendo de la opción seleccionada
  /// en el Drawer (representada por [NavItemNormal]), se muestra el contenido correspondiente.
  ///
  /// Se utiliza [BlocProvider] y [BlocConsumer] para gestionar el estado del Drawer a través
  /// de [NavDrawerBlocNormal] y actualizar la interfaz de forma reactiva.

class HomeNormal extends StatefulWidget {
  const HomeNormal({super.key});

  @override
  State<HomeNormal> createState() => _HomeNormalState();
}

class _HomeNormalState extends State<HomeNormal> {
  // Servicio de autenticación para obtener datos del usuario.
  late AuthService authServiceNormal;

  // Bloc que gestiona el estado del Drawer y la navegación.
  late NavDrawerBlocNormal _blocNormal;

  // Widget que contiene el contenido actual que se mostrará según la opción del Drawer.
  late Widget _contentNormal;

  // Variable para guardar el valor del CUPO
  String? userCupo; 

  @override
  void initState() {
    super.initState();
    authServiceNormal = AuthService();
    _blocNormal = NavDrawerBlocNormal();
    // Se inicializa el contenido en función de la opción seleccionada en el Drawer.
    _contentNormal = _getContentForStateNormal(_blocNormal.state.selected);
    _loadUserCupo();
  }

  Future<void> _loadUserCupo() async {
    try {
      // Se obtiene el correo del usuario actual para pasarlo al Drawer.
      String? uid = authServiceNormal.getCurrentUserUid();
      print('UID del usuario: $uid');
      if (uid != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('uid', isEqualTo: uid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          String cupo = userData['CUPO'];

          final employeeSnapshot = await FirebaseFirestore.instance
              .collection('Empleados')
              .where('CUPO', isEqualTo: cupo)
              .get();

          if (employeeSnapshot.docs.isNotEmpty) {
            setState(() {
              userCupo = cupo;
              print('CUPO obtenido: $userCupo');
            });
          } else {
            print('Empleado no encontrado');
          }
        } else {
          print('Usuario no encontrado');
        }
      } else {
        print('UID es nulo');
      }
    } catch (e) {
      print('Error al obtener CUPO: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el correo del usuario actual para pasarlo al Drawer.
    String? userEmailNormal = authServiceNormal.getCurrentUserEmail();

    return BlocProvider(
      // Se provee el NavDrawerBlocNormal para que el resto de la interfaz pueda reaccionar
      // a los cambios en la navegación.
      create: (context) => _blocNormal,
      child: BlocConsumer<NavDrawerBlocNormal, NavDrawerStateNormal>(
        // Escucha cambios en el estado del Drawer y actualiza el contenido correspondiente.
        listener: (BuildContext context, NavDrawerStateNormal state) {
          setState(() {
            _contentNormal = _getContentForStateNormal(state.selected);
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
                    _getAppbarTitleNormal(state.selected),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  shadowColor: Colors.black,
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  actions: [
  IconButton(
    splashRadius: 35.0,
    iconSize: 30.0,
    tooltip: 'Notificaciones',
    icon: const Icon(Icons.notifications_rounded),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => UserNotificationsPage(),
      );
    },
  ),
],

                ),
                // En pantallas pequeñas se muestra el Drawer como menú lateral.
                drawer: isLargeScreen ? null : NavDrawerWidgetNormal(userEmail: userEmailNormal),
                body: Row(
                  children: [
                    // En pantallas grandes se muestra el Drawer en forma permanente.
                    if (isLargeScreen)
                      SizedBox(
                        width: 300, // Ancho fijo para el Drawer en pantallas grandes.
                        child: NavDrawerWidgetNormal(userEmail: userEmailNormal),
                      ),
                    // Área que muestra el contenido actual basado en la navegación.
                    Expanded(child: _contentNormal),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Retorna el contenido correspondiente en función del [NavItemNormal] del Drawer.
  ///
  /// Este metodo determina qué widget se debe mostrar en la pantalla principal
  /// según la opción seleccionada en el menú lateral.

  Widget _getContentForStateNormal(NavItemNormal selected) {
    switch (selected) {
      case NavItemNormal.homeUserView:
        return const DashboardNormal();
      case NavItemNormal.cursosView:
        if (userCupo != null) {
          return DynamicCourseSelectionPage(cupo: userCupo!); // Pasar el CUPO
        } else {
          return const Center(child: CircularProgressIndicator()); // Mostrar cargando si el CUPO aún no está disponible
        }
      case NavItemNormal.configuracionUserView:
        return const ConfigurationNormal();
      case NavItemNormal.cerrarSesionView:
        return const CerrarSesion();
      }
  }

  /// Retorna el título que se debe mostrar en el AppBar en función del [NavItemNormal].
  ///
  /// Este metodo asocia cada opción del Drawer con un título específico.

  String _getAppbarTitleNormal(NavItemNormal selected) {
    switch (selected) {
      case NavItemNormal.homeUserView:
        return "Inicio";
      case NavItemNormal.cursosView:
        return "Mis cursos";
      case NavItemNormal.configuracionUserView:
        return "Configuración";
      case NavItemNormal.cerrarSesionView:
        return "Cerrar Sesión";
      }
  }
}
