import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'dart:html' as html;

Future<void> generarExcelCursosCompletados() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot cursosCompletadosSnapshot =
      await firestore.collection('CursosCompletados').get();

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Cursos Completados'];

  Set<String> dependenciasSet = {};

  // Recoger todas las dependencias únicas
  for (var doc in cursosCompletadosSnapshot.docs) {
    List<String> idCursos = List<String>.from(doc['IdCursosCompletados']);

    for (String cursoId in idCursos) {
      DocumentSnapshot cursoSnapshot =
          await firestore.collection('Cursos').doc(cursoId).get();

      if (cursoSnapshot.exists) {
        String dependencia = cursoSnapshot['Dependencia'] ?? 'S/D';
        dependenciasSet.add(dependencia);
      }
    }
  }

  List<String> dependenciasOrdenadas = dependenciasSet.toList()..sort();

  // Encabezados principales
  List<CellValue?> encabezadoDependencias = [
    TextCellValue('CUPO'),
    TextCellValue('Nombre del Empleado')
  ];
  for (String dependencia in dependenciasOrdenadas) {
    encabezadoDependencias.add(TextCellValue(dependencia));
    encabezadoDependencias.add(TextCellValue(''));
    encabezadoDependencias.add(TextCellValue(''));
  }
  sheetObject.appendRow(encabezadoDependencias);

  // Subencabezados
  List<CellValue?> subEncabezados = [TextCellValue(''), TextCellValue('')];
  for (String dependencia in dependenciasOrdenadas) {
    subEncabezados.add(TextCellValue('Curso'));
    subEncabezados.add(TextCellValue('Trimestre'));
    subEncabezados.add(TextCellValue('Fecha Completado'));
  }
  sheetObject.appendRow(subEncabezados);

  // Procesar cada empleado
  for (var doc in cursosCompletadosSnapshot.docs) {
    String uid = doc['uid'];
    List<String> idCursos = List<String>.from(doc['IdCursosCompletados']);
    List<String> fechasCursos = (doc['FechaCursoCompletado'] as List)
        .map((fecha) => (fecha as Timestamp).toDate().toIso8601String())
        .toList();

    DocumentSnapshot userSnapshot =
        await firestore.collection('User').doc(uid).get();
    String cupon = userSnapshot['CUPO'] ?? 'S/D';

    String empleadoNombre = 'Desconocido';
    if (cupon.isNotEmpty) {
      QuerySnapshot empleadosSnapshot = await firestore
          .collection('Empleados')
          .where('CUPO', isEqualTo: cupon)
          .get();

      if (empleadosSnapshot.docs.isNotEmpty) {
        empleadoNombre = empleadosSnapshot.docs.first['Nombre'] ?? 'Desconocido';
      }
    }

    // Mapa para organizar los cursos por dependencia
    Map<String, List<List<String>>> datosPorDependencia = {};

    for (int i = 0; i < idCursos.length; i++) {
      String cursoId = idCursos[i];
      String fechaCurso = fechasCursos[i];

      DocumentSnapshot cursoSnapshot =
          await firestore.collection('Cursos').doc(cursoId).get();

      if (cursoSnapshot.exists) {
        String nombreCurso = cursoSnapshot['NombreCurso'] ?? 'Desconocido';
        String trimestre = cursoSnapshot['Trimestre'] ?? '0';
        String dependenciaCurso = cursoSnapshot['Dependencia'] ?? 'S/D';

        if (!datosPorDependencia.containsKey(dependenciaCurso)) {
          datosPorDependencia[dependenciaCurso] = [];
        }
        datosPorDependencia[dependenciaCurso]!.add([
          nombreCurso,
          trimestre,
          fechaCurso.split("T")[0]
        ]);
      }
    }

    // Encontrar la cantidad máxima de filas que se necesitarán
    int maxCursosPorEmpleado = datosPorDependencia.values
        .map((lista) => lista.length)
        .fold(0, (prev, curr) => curr > prev ? curr : prev);

    // Crear filas dinámicamente según el número de cursos
    for (int i = 0; i < maxCursosPorEmpleado; i++) {
      List<CellValue?> fila = [];

      if (i == 0) {
        // Solo en la primera fila escribimos los datos del empleado
        fila.add(TextCellValue(cupon));
        fila.add(TextCellValue(empleadoNombre));
      } else {
        // Filas adicionales dejan vacío CUPO y Nombre
        fila.add(TextCellValue(''));
        fila.add(TextCellValue(''));
      }

      // Agregar los cursos en la misma fila
      for (String dependencia in dependenciasOrdenadas) {
        if (datosPorDependencia.containsKey(dependencia) &&
            datosPorDependencia[dependencia]!.length > i) {
          var datos = datosPorDependencia[dependencia]![i];
          fila.add(TextCellValue(datos[0])); // Curso
          fila.add(TextCellValue(datos[1])); // Trimestre
          fila.add(TextCellValue(datos[2])); // Fecha
        } else {
          fila.addAll([
            TextCellValue(''),
            TextCellValue(''),
            TextCellValue('')
          ]);
        }
      }

      sheetObject.appendRow(fila);
    }
  }

  await guardarYAbrirExcel(excel);
}



Future<void> guardarYAbrirExcel(Excel excel) async {
  var bytes = excel.encode();
  if (bytes == null) return;

  Uint8List uint8List = Uint8List.fromList(bytes);
  final blob = html.Blob([uint8List]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "CursosCompletados.xlsx")
    ..click();

  html.Url.revokeObjectUrl(url);
  print('📂 Archivo descargado exitosamente.');
}
