import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/ink_component.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

/// El widget `MyPaginatedTable` recibe una lista de encabezados, claves de campos y datos
/// (en forma de mapas) para renderizar una tabla. Además, permite ejecutar funciones para editar,
/// eliminar, activar o asignar elementos a partir de un identificador único.

class MyPaginatedTable extends StatefulWidget {
  final List<String> headers; // Lista de encabezados que se mostrarán en la cabecera de la tabla.
  final List<String> fieldKeys; // Lista de claves de los campos que se utilizarán para extraer los datos a mostrar.
  final List<Map<String, dynamic>> data; // Lista de datos que se mostrarán en la tabla.
  final String idKey; // Clave utilizada para identificar de forma única cada registro en los datos.
  final Function(String id) onEdit; // Función para editar
  final Function(String id) onDelete; // Función para eliminar
  /// Estado del botón dinámico: si es verdadero se muestra la acción de eliminar,
  /// si es falso se muestra la acción de activar.
  final bool onActive;
  final Function(String id) activateFunction; //Función que se ejecuta para activar un registro.
  final Function(String id)? onAssign; // Función opcional
  final Icon? iconAssign; // Icono del metodo opcional
  final String? tooltipAssign; // Texto opcional para el tooltip de la acción de asignación.

  const MyPaginatedTable({
    super.key,
    required this.headers,
    required this.data,
    required this.fieldKeys,
    required this.onEdit,
    required this.onDelete,
    this.onAssign,
    required this.idKey,
    required this.onActive,
    required this.activateFunction,
    this.iconAssign,
    this.tooltipAssign,
  });

  @override
  State<MyPaginatedTable> createState() => _MyPaginatedTableState();
}

class _MyPaginatedTableState extends State<MyPaginatedTable> {
  int _rowsPerPage = 5; // Número inicial de filas por página

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: PaginatedDataTable(
              columnSpacing: 20,
              // Construcción de las columnas a partir de los encabezados recibidos.
              columns: [
                ...widget.headers.map((header) {
                  return DataColumn(
                    label: Expanded(child: Text(
                      header,
                      style: TextStyle(fontSize: responsiveFontSize(context, 16), fontWeight: FontWeight.bold),
                    )),
                  );
                }),
                // Columna adicional para las acciones (editar, eliminar, asignar).
                DataColumn(
                  label: Expanded(child: Text(
                    'Acciones',
                    style: TextStyle(fontSize: responsiveFontSize(context, 16), fontWeight: FontWeight.bold),
                  )),
                ),
              ],
              // Fuente de datos personalizada para la tabla.
              source: _TableDataSource(
                data: widget.data,
                fieldKeys: widget.fieldKeys,
                idKey: widget.idKey,
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
                onActive: widget.onActive,
                activateFunction: widget.activateFunction,
                onAssign: widget.onAssign,
                iconAssign: widget.iconAssign,
                tooltipAssign: widget.tooltipAssign,
              ),
              rowsPerPage: _rowsPerPage, // Número de filas por pagina.
              availableRowsPerPage: const [5, 10], // Valores para cambiar el numero de registros por pagina.
              onRowsPerPageChanged: (value) {
                setState(() {
                  if(value != null) {
                    _rowsPerPage = value;
                  }
                });
              },
            ),
          );
        });
  }
}

  /// Fuente de datos para la tabla paginada.
  ///
  /// Esta clase extiende de [DataTableSource] y es responsable de construir cada fila
  /// de la tabla a partir de los datos proporcionados.
class _TableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data; // Datos a mostrar en la tabla.
  final List<String> fieldKeys; // Lista de claves de los campos que se utilizarán para extraer los valores.
  final String idKey; // Clave utilizada para identificar de forma única cada registro.
  final Function(String id) onEdit; // Función de editar
  final Function(String id) onDelete; // Función de eliminar
  /// Estado del botón dinámico: si es verdadero se muestra la acción de eliminar,
  /// si es falso se muestra la acción de activar.
  final bool onActive;
  final Function(String id) activateFunction; //Función que se ejecuta para activar un registro.
  final Function(String id)? onAssign; // Función opcional
  final Icon? iconAssign; // Icono del metodo opcional
  final String? tooltipAssign; // Texto opcional para el tooltip de la acción de asignación.

  // Constructor para inicializar la fuente de datos.
  _TableDataSource({
    required this.data,
    required this.fieldKeys,
    required this.idKey,
    required this.onEdit,
    required this.onDelete,
    required this.onActive,
    required this.activateFunction,
    this.onAssign,
    this.iconAssign,
    this.tooltipAssign,
  });

  // Configuración de filas y datos de celda para un DataTable.
  @override
  DataRow getRow(int index) {
    if (index >= data.length) return const DataRow(cells: []);
    final rowData = data[index];
    return DataRow(
      cells: [
        // Primera celda con un ancho mayor
        DataCell(
          SizedBox(
            width: 300, // Ajusta este valor según sea necesario
            child: Text(
              rowData[fieldKeys.first]?.toString() ?? '',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Otras celdas con un ancho menor
        ...fieldKeys.skip(1).map((key) {
          return DataCell(
            SizedBox(
              width: 150, // Ancho estándar para las demás celdas
              child: Text(
                rowData[key]?.toString() ?? '',
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
        // Celda de acciones que contiene botones para editar, eliminar/activar y asignar.
        DataCell(
          Row(
            children: [
              // Botón de editar.
              InkComponent(tooltip: 'Editar',
                  iconInk: const Icon(Icons.edit, color: greenColorLight),
                  inkFunction: () => onEdit(rowData[idKey].toString())),
              // Botón para eliminar o activar, dependiendo del estado.
              InkComponent(
                  tooltip: onActive ? "Eliminar" : "Activar",
                  iconInk: Icon(onActive ? Icons.delete_forever_sharp : Icons.power_settings_new,
                  color: Colors.red,
                  ),
                  inkFunction: () {
                    // Validaciones para el boton de eliminar/activar, en caso de ocurrir un error
                    // se registra en Sentry
                    if (onActive) {
                      try {
                        onDelete(rowData[idKey].toString());
                      } catch (e, stackTrace) {
                        Sentry.captureException(e, stackTrace: stackTrace,
                        withScope: (scope) {
                          scope.setTag('Error_delete_PaginatedTable', rowData[idKey].toString());
                        });
                      }
                    } else {
                      try {
                        activateFunction(rowData[idKey].toString());
                      } catch (e, stackTrace) {
                        Sentry.captureException(e, stackTrace: stackTrace,
                        withScope: (scope) {
                          scope.setTag('Error_activate_PaginatedTable', rowData[idKey].toString());
                        }
                        );
                      }
                    }
                  },),
              // Botón opcional para asignar, solo se muestra si se proporciona la función.
              if (onAssign != null)
                InkComponent(
                    tooltip: tooltipAssign!,
                    iconInk: iconAssign ?? const Icon(Icons.assignment),
                    inkFunction: () => onAssign!(rowData[idKey].toString())),
            ],
          ),
        ),
      ],
    );
  }

  /// Estas tres propiedades son parte de la implementación de la interfaz (o clase abstracta)
  /// DataTableSource que se utiliza en el widget PaginatedDataTable para proporcionar los datos
  /// de la tabla

  @override
  bool get isRowCountApproximate => false; // Indica si el número de filas proporcionado es exacto o solo una estimación.

  @override
  int get rowCount => data.length; // Devuelve el número total de filas disponibles en la fuente de datos.

  @override
  int get selectedRowCount => 0; // Indica cuántas filas están actualmente seleccionadas en la tabla.
}