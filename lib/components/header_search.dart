import 'package:flutter/material.dart';
import '../dataConst/constand.dart';
import '../util/responsive.dart';

class HeaderSearch extends StatelessWidget {
  final TextEditingController searchInput;
  final ValueChanged<String> onSearch;
  final VoidCallback onToggleView;
  final bool viewInactivos;
  final String title;
  final String viewOn;
  final String viewOff;

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
        Expanded(
            flex: 3,
            child: Text(title, style: TextStyle(
              fontSize: responsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            )),
        ),
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
