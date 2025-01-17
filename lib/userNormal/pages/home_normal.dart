import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/pages/configuration/cerrar_sesion.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_block_normal.dart';
import 'package:testwithfirebase/userNormal/blockNormal/drawer_state_normal.dart';
import 'package:testwithfirebase/userNormal/components/drawerNormal/drawer_widget_normal.dart';
import 'package:testwithfirebase/userNormal/pages/CourseSelectionPage.dart';
import 'package:testwithfirebase/userNormal/pages/configuration_normal.dart';
import 'package:testwithfirebase/userNormal/pages/dashboard_normal.dart';

class HomeNormal extends StatefulWidget {
  const HomeNormal({super.key});

  @override
  State<HomeNormal> createState() => _HomeNormalState();
}

class _HomeNormalState extends State<HomeNormal> {
  late AuthService authServiceNormal;
  late NavDrawerBlocNormal _blocNormal;
  late Widget _contentNormal;

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  String? userCupo; 

  @override
  void initState() {
    super.initState();
    authServiceNormal = AuthService();
    _blocNormal = NavDrawerBlocNormal();
    _contentNormal = _getContentForStateNormal(_blocNormal.state.selected);
    _loadUserCupo();
  }

  Future<void> _loadUserCupo() async {
    try {
      String? uid = authServiceNormal.getCurrentUserUid(); // Obtener el UID del usuario actual
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
              .collection('Employee')
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
    String? userEmailNormal = authServiceNormal.getCurrentUserEmail();

    return BlocProvider(
      create: (context) => _blocNormal,
      child: BlocConsumer<NavDrawerBlocNormal, NavDrawerStateNormal>(
        listener: (BuildContext context, NavDrawerStateNormal state) {
          setState(() {
            _contentNormal = _getContentForStateNormal(state.selected);
          });
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isLargeScreen = constraints.maxWidth > 800;

              return Scaffold(
                appBar: AppBar(
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
                      icon: const Icon(
                        Icons.notifications_rounded,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                // Drawer se muestra dependiendo del tamaño de pantalla
                drawer: isLargeScreen ? null : NavDrawerWidgetNormal(userEmail: userEmailNormal),
                body: Row(
                  children: [
                    if (isLargeScreen)
                      SizedBox(
                        width: 300,
                        child: NavDrawerWidgetNormal(userEmail: userEmailNormal),
                      ),
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
