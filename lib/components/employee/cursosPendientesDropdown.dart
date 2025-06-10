 import 'package:flutter/material.dart';

/// Un widget personalizado que muestra un DropdownButtonFormField para
/// seleccionar un curso pendiente de una lista de cursos obtenida de Firestore.

/// Este widget utiliza un FutureBuilder para esperar la lista de cursos, mostrando un indicador 
/// de carga mientras se obtienen los datos. Si hay un error o la lista está vacía, muestra un 
/// mensaje de error o un texto indicativo respectivamente.

/// Parámetros:
/// - [cursosFuture]: Un Future que devuelve una lista de mapas, cada uno
///   representando un curso con los campos 'IdCurso' y 'NombreCurso'.
/// - [onChanged]: Un callback opcional que se invoca cuando el usuario selecciona
///   un curso. Recibe el ID del curso seleccionado como String?.
/// 
/// Notas:
/// - Los datos del curso deben incluir las claves 'IdCurso' y 'NombreCurso' como
///   String?.
/// - Los cursos con datos faltantes o nulos serán filtrados y no aparecerán
///   en la lista desplegable.

class CursosPendientesDropdown extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> cursosFuture;
  final Function(Map<String, dynamic>?)? onChanged;

  const CursosPendientesDropdown({
    super.key,
    required this.cursosFuture,
    this.onChanged,
  });

  @override
  State<CursosPendientesDropdown> createState() => _CursosPendientesDropdownState();
}

class _CursosPendientesDropdownState extends State<CursosPendientesDropdown> {
  String? selectedIdCurso;
  List<Map<String, dynamic>> cursos = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.cursosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay cursos pendientes');
        }

        cursos = snapshot.data!
            .where((curso) => curso['IdCurso'] != null && curso['NombreCurso'] != null)
            .toList();

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Cursos Pendientes',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          value: selectedIdCurso,
          items: cursos.map((curso) {
            return DropdownMenuItem<String>(
              value: curso['IdCurso'],
              child: Text(curso['NombreCurso']),
            );
          }).toList(),
          onChanged: (idCurso) {
            setState(() {
              selectedIdCurso = idCurso;
            });
            final cursoSeleccionado =
                cursos.firstWhere((curso) => curso['IdCurso'] == idCurso);
            if (widget.onChanged != null) {
              widget.onChanged!(cursoSeleccionado);
            }
          },
        );
      },
    );
  }
}
