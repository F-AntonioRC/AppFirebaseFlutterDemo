import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

Future<void> importExcelWithSareToFirebase() async {
  // Obtener el mapa de Sares con sus IDs
  Map<String, String> sareMap = await fetchSareIds();

  // Seleccionar el archivo Excel
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'], // Solo archivos Excel
    withData: true,
  );

  if (result != null) {
    Uint8List fileBytes = result.files.single.bytes!;

    // Leer el archivo Excel
    var excel = Excel.decodeBytes(fileBytes);

    // Procesar cada hoja
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;

      // Iterar por las filas (a partir de la segunda, si la primera es la cabecera)
      for (int i = 1; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];

        // Obtener el nombre del Sare desde el Excel
        String sareName = row[5]?.value?.toString() ?? ''; // Suponiendo que el nombre del Sare está en la columna 5

        // Buscar el IdSare correspondiente
        String? idSare = sareMap[sareName];

        // Si el IdSare no existe, manejarlo (puedes lanzar un error o ignorar la fila)
        if (idSare == null) {
          print('El Sare "$sareName" no existe en la colección Sare.');
          continue; // Ignorar esta fila y pasar a la siguiente
        }

        // Generar un ID aleatorio para el empleado
        final String id = randomAlphaNumeric(5);

        // Crear el mapa de datos para el empleado
        Map<String, dynamic> data = {
          'id': id,
          'CUPO': row[0]?.value?.toString() ?? '',
          'Estado': row[1]?.value?.toString() ?? '',
          'Nombre': row[2]?.value?.toString() ?? '',
          'Puesto': row[3]?.value?.toString() ?? '',
          'correo': row[4]?.value?.toString() ?? '',
          'Sare': sareName, // Nombre del Sare (opcional)
          'IdSare': idSare, // ID del Sare relacionado
          'Sexo': row[6]?.value?.toString() ?? '',
          'Area': row[7]?.value?.toString() ?? '',
        };

        // Subir los datos a Firebase
        await FirebaseFirestore.instance.collection('Empleados').doc(id).set(data);
      }
    }
    print("Datos importados exitosamente.");
  } else {
    print("No se seleccionó ningún archivo.");
  }
}

Future<Map<String, String>> fetchSareIds() async {
  Map<String, String> sareMap = {};

  // Obtén todos los documentos de la colección Sare
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Sare').get();

  // Crea un mapa con nombre del Sare como clave y IdSare como valor
  for (var doc in snapshot.docs) {
    sareMap[doc['sare']] = doc.id; // Asegúrate de que 'nombre' es el campo correcto en tu colección Sare
  }

  return sareMap;
}
