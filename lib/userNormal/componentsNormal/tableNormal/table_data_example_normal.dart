
class TableDataExampleNormal {
  /// Crea una lista de columnas para el Widget `TableExample`.

  static List<String> getColumns() =>  [ 'Nombre del curso', 'Fecha de envio de Constancia'];

  /// Crea una lista de filas con datos para el Widget `TableExample`.

  static List<Map<String, dynamic>> getRows() => [
    {'Nombre del curso' : 'Uso de la computadora',
     'Fecha de envio de Constancia' : '5 de febrero de 2025, 1:42:14p.m. UTC-6'
    },
    {'Nombre del curso' : 'Cuidado del planeta',
      'Fecha de envio de Constancia' : '6 de febrero de 2025, 6:45:03.m. UTC-6'
    },
    {'Nombre del curso' : 'Seguridad en internet',
      'Fecha de envio de Constancia' : '7 de febrero de 2025, 10:30:45 a.m. UTC-6'
    },
    {'Nombre del curso' : 'Hábitos saludables',
      'Fecha de envio de Constancia' : '8 de febrero de 2025, 2:15:30 p.m. UTC-6'
    },
    {'Nombre del curso' : 'Trabajo en equipo',
      'Fecha de envio de Constancia' : '9 de febrero de 2025, 4:20:50 p.m. UTC-6'
    },
    {'Nombre del curso' : 'Creatividad e innovación',
      'Fecha de envio de Constancia' : '10 de febrero de 2025, 11:10:22 a.m. UTC-6'
    },
    {'Nombre del curso' : 'Desarrollo personal',
      'Fecha de envio de Constancia' : '11 de febrero de 2025, 9:05:14 a.m. UTC-6'
    },
  ];
}