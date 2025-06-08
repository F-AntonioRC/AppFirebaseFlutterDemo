import 'package:flutter/material.dart';

/// Un widget personalizado que muestra un `DropdownButtonFormField` para
/// seleccionar un curso pendiente de una lista de cursos obtenida de Firestore.

/// Este widget utiliza un `FutureBuilder` para esperar la lista de cursos, mostrando un indicador 
/// de carga mientras se obtienen los datos. Si hay un error o la lista está vacía, muestra un 
/// mensaje de error o un texto indicativo respectivamente.

/// Parámetros:
/// - [cursosFuture]: Un `Future` que devuelve una lista de mapas, cada uno
///   representando un curso con los campos 'IdCurso' y 'NombreCurso'.
/// - [onChanged]: Un callback opcional que se invoca cuando el usuario selecciona
///   un curso. Recibe el ID del curso seleccionado como `String?`.
/// 
/// Notas:
/// - Los datos del curso deben incluir las claves 'IdCurso' y 'NombreCurso' como
///   `String?`.
/// - Los cursos con datos faltantes o nulos serán filtrados y no aparecerán
///   en la lista desplegable.

class CursosPendientesDropdown extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> cursosFuture;
  final Function(String?)? onChanged;

  const CursosPendientesDropdown({
    super.key,
    required this.cursosFuture,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: cursosFuture,
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

        final cursos = snapshot.data!;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Cursos Pendientes',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: cursos.map((curso) {
            final idCurso = curso['IdCurso'] as String?;
            final nombreCurso = curso['NombreCurso'] as String?;
            if (idCurso == null || nombreCurso == null) {
              return null;
            }
            return DropdownMenuItem<String>(
              value: idCurso,
              child: Text(nombreCurso),
            );
          }).whereType<DropdownMenuItem<String>>().toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}
