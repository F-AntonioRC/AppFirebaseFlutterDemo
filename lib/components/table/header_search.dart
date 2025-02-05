import 'package:flutter/material.dart';
import '../../dataConst/constand.dart';
import '../../util/responsive.dart';

  /// Este widget se utiliza para la cabecera del componente [MyPaginatedTable] donde se
  /// requiere:
  /// - Mostrar un título.
  /// - Permitir la búsqueda mediante un [TextField].
  /// - Alternar entre dos modos de vista (por ejemplo, activos/inactivos) mediante un botón.

class HeaderSearch extends StatelessWidget {
  final TextEditingController searchInput; // Controlador para el campo de búsqueda.
  final ValueChanged<String> onSearch; // Callback que se invoca cuando el usuario escribe en el campo de búsqueda.
  final VoidCallback onToggleView; // Callback que se invoca al presionar el botón para alternar la vista.
  final bool viewInactivos; // Indicador para la vista de elementos inactivos
  final String title; // Título que se muestra en la cabecera.
  final String viewOn; // Texto que se muestra en el tooltip del botón cuando la vista activa está habilitada.
  final String viewOff; // Texto que se muestra en el tooltip del botón cuando la vista inactiva está habilitada.

  const HeaderSearch({super.key,
    required this.searchInput,
    required this.onSearch,
    required this.onToggleView,
    required this.viewInactivos,
    required this.title,
    required this.viewOn,
    required this.viewOff});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Título del encabezado.
        Expanded(
            flex: 3,
            child: Text(title, style: TextStyle(
              fontSize: responsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            )),
        ),
        // Campo de búsqueda.
        Expanded(
            flex: 2,
            child: TextField(
              controller: searchInput,
              decoration: const InputDecoration(
              hintText: "Escribe para buscar...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ), onChanged : onSearch,
            )
        ),
        const SizedBox(width: 10.0),
        // Botón para alternar la vista entre activos/inactivos.
        Ink(
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: greenColor,
          ),
          child: IconButton(
            onPressed: onToggleView,
            tooltip: viewInactivos
                ? viewOff
                : viewOn,
            icon: Icon(
              viewInactivos ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20.0)
      ],
    );
  }
}
