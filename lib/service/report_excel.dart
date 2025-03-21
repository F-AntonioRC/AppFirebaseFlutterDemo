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

  List<CellValue?> subEncabezados = [TextCellValue(''), TextCellValue('')];
  for (String dependencia in dependenciasOrdenadas) {
    subEncabezados.add(TextCellValue('Curso'));
    subEncabezados.add(TextCellValue('Trimestre'));
    subEncabezados.add(TextCellValue('Fecha Completado'));
  }
  sheetObject.appendRow(subEncabezados);

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

    List<List<CellValue?>> filaExpandida = [];
    filaExpandida.add([TextCellValue(cupon), TextCellValue(empleadoNombre)]);

    for (String dependencia in dependenciasOrdenadas) {
      List<String> cursos = [];
      List<String> trimestres = [];
      List<String> fechas = [];

      for (int i = 0; i < idCursos.length; i++) {
        String cursoId = idCursos[i];
        String fechaCurso = fechasCursos[i];

        DocumentSnapshot cursoSnapshot =
            await firestore.collection('Cursos').doc(cursoId).get();

        if (cursoSnapshot.exists) {
          String nombreCurso = cursoSnapshot['NombreCurso'] ?? 'Desconocido';
          String trimestre = cursoSnapshot['Trimestre'] ?? '0';
          String dependenciaCurso = cursoSnapshot['Dependencia'] ?? 'S/D';

          if (dependenciaCurso == dependencia) {
            cursos.add(nombreCurso);
            trimestres.add(trimestre);
            fechas.add(fechaCurso.split("T")[0]);
          }
        }
      }

      int maxFilas = cursos.length;
      for (int i = 0; i < maxFilas; i++) {
        if (filaExpandida.length <= i) {
          filaExpandida.add([TextCellValue(''), TextCellValue('')]);
        }
        filaExpandida[i].add(TextCellValue(cursos[i]));
        filaExpandida[i].add(TextCellValue(trimestres[i]));
        filaExpandida[i].add(TextCellValue(fechas[i]));
      }

      if (maxFilas == 0) {
        if (filaExpandida.length == 1) {
          filaExpandida[0].addAll([
            TextCellValue(''),
            TextCellValue(''),
            TextCellValue('')
          ]);
        } else {
          for (var row in filaExpandida) {
            row.addAll([
              TextCellValue(''),
              TextCellValue(''),
              TextCellValue('')
            ]);
          }
        }
      }
    }

    for (var row in filaExpandida) {
      sheetObject.appendRow(row);
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
