import 'package:flutter/material.dart';
import 'package:testwithfirebase/bloc/drawer_bloc.dart'; // Importa el Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testwithfirebase/bloc/drawer_state.dart';
import 'package:testwithfirebase/components/drawer_widget.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Maneja las páginas que cambian dinámicamente
  final Map<NavItem, Widget> _pages = {
    NavItem.homeView: const HomePage(),
    NavItem.courseView: const CoursesPage(),
    NavItem.emailView: const EmailPage(),
  };

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return BlocBuilder<NavDrawerBloc, NavDrawerState>(
      builder: (context, state) {
        return Scaffold(
          drawer: !isDesktop
              ? const SizedBox(
            width: 250,
            child: NavDrawerWidget(userEmail: 'user@example.com'), // Drawer en móvil
          )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                // En pantallas grandes, muestra el Drawer fijo
                if (isDesktop)
                  const SizedBox(
                    width: 250,
                    child: NavDrawerWidget(userEmail: 'user@example.com'),
                  ),

                // Página principal que cambia según la selección en el Drawer
                Expanded(
                  flex: 7,
                  child: _pages[state.selectedItem] ?? const HomePage(), // Muestra la página seleccionada
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Ejemplos de las páginas que cambian
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página de Inicio'),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página de Cursos'),
    );
  }
}

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página de Email'),
    );
  }
}
