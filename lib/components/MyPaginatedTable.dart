import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class MyPaginatedTable extends StatefulWidget {
  final List<String> headers; // Cabeceras de la tabla
  final List<String> fieldKeys; // Atributos que se muestran
  final List<Map<String, dynamic>> data; // Datos almacenados
  final String idKey; // Valor del id
  final Function(String id) onEdit; // Función para editar
  final Function(String id) onDelete; // Función para eliminar
  final bool onActive; // Estado del botón dinámico
  final Function(String id) activateFunction;
  final Function(String id)? onAssign; // Función opcional
  final Icon? iconAssign; // Icono del método opcional
  final String? tooltipAssign;

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
          return SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              child: PaginatedDataTable(
                columns: [
                  ...widget.headers.map((header) {
                    return DataColumn(
                      label: Expanded(child: Text(
                        header,
                        style: TextStyle(fontSize: responsiveFontSize(context, 18), fontWeight: FontWeight.bold),
                      )),
                    );
                  }),
                  DataColumn(
                    label: Expanded(child: Text(
                      'Acciones',
                      style: TextStyle(fontSize: responsiveFontSize(context, 18), fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
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
                rowsPerPage: _rowsPerPage, // Número de filas por página
                availableRowsPerPage: const [5, 10],
                onRowsPerPageChanged: (value) {
                  setState(() {
                    if(value != null) {
                      _rowsPerPage = value;
                    }
                  });
                },
              ),
            ),
          );
        });
  }
}

class _TableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final List<String> fieldKeys;
  final String idKey;
  final Function(String id) onEdit;
  final Function(String id) onDelete;
  final bool onActive;
  final Function(String id) activateFunction;
  final Function(String id)? onAssign;
  final Icon? iconAssign;
  final String? tooltipAssign;

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

  @override
  DataRow getRow(int index) {
    if (index >= data.length) return const DataRow(cells: []);
    final rowData = data[index];

    return DataRow(
      cells: [
        ...fieldKeys.map((key) {
          return DataCell(Text(
            rowData[key]?.toString() ?? '',
            style: const TextStyle(fontSize: 16),
          ));
        }),
        DataCell(
          Row(
            children: [
              Ink(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
                child: IconButton(
                  tooltip: "Editar",
                  icon: const Icon(Icons.edit, color: greenColor),
                  onPressed: () => onEdit(rowData[idKey].toString()),
                ),
              ),
              Ink(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
                child: IconButton(
                  tooltip: onActive ? "Eliminar" : "Activar",
                  icon: Icon(onActive ? Icons.delete_forever_sharp : Icons.power_settings_new),
                  color: onActive ? Colors.red : Colors.red,
                  onPressed: () {
                    if (onActive) {
                      try {
                        onDelete(rowData[idKey].toString());
                      } catch (e) {
                        //Manejo de errores
                      }
                    } else {
                      activateFunction(rowData[idKey].toString());
                    }
                  },
                ),
              ),
              if (onAssign != null)
                Ink(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
                  child: IconButton(
                    tooltip: tooltipAssign,
                    icon: iconAssign ?? const Icon(Icons.assignment),
                    onPressed: () => onAssign!(rowData[idKey].toString()),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
