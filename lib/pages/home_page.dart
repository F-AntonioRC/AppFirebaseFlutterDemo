import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/auth/auth_service.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/components/drawer_widget.dart';
import 'package:testwithfirebase/pages/courses.dart';
import 'package:testwithfirebase/pages/empoyee.dart';
import 'package:testwithfirebase/pages/screen_employee.dart';
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

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    _bloc = NavDrawerBloc();
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  void logout() {
    final auth = AuthService();
    auth.signOut();
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.lightBlue,
                  shadowColor: Colors.grey,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4C60AF),
                          Color.fromARGB(255, 37, 195, 248),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  scrolledUnderElevation: 10.0,
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  actions: [
                    IconButton(
                      splashRadius: 35.0,
                      iconSize: 30.0,
                      tooltip: 'Salir',
                      onPressed: logout,
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                // Drawer se muestra dependiendo del tamaño de pantalla
                drawer: isLargeScreen ? null : NavDrawerWidget(userEmail: userEmail),
                body: Row(
                  children: [
                    if (isLargeScreen)
                      SizedBox(
                        width: 250, // Ancho del Drawer en pantallas grandes
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
        return const ScreenEmployee();
      case NavItem.courseView:
        return const Courses();
      case NavItem.emailView:
        return const SendEmail();
      default:
        return const ScreenEmployee();
    }
  }

  String _getAppbarTitle(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeView:
        return "Home";
      case NavItem.courseView:
        return "Courses";
      case NavItem.emailView:
        return "Email";
      default:
        return "Navigation Drawer Demo";
    }
  }
}
