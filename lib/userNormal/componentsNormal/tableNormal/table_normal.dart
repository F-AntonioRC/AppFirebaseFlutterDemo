import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/tableNormal/paginated_table_normal.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/tableNormal/table_data_example_normal.dart';
import 'package:testwithfirebase/userNormal/serviceuser/paginated_table_service.dart';
import 'package:testwithfirebase/util/responsive.dart';

class TableNormal extends StatefulWidget {
  const TableNormal({super.key});

  @override
  State<TableNormal> createState() => _TableNormalState();
}

class _TableNormalState extends State<TableNormal> {
  bool isLoading = true;
  List<Map<String, dynamic>> rows = [];
  final List<String> columns = ['NOMBRE DEL CURSO', 'TRIMESTRE',
    'FECHA DE FINALIZACIÓN'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final paginatedTableService = PaginatedTableService();
    List<Map<String, dynamic>> fetchedRows = await paginatedTableService.fetchCompletedCourses();

    setState(() {
      rows = fetchedRows;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Aquí podrás ver los cursos que has completado',
            style: TextStyle(
                fontSize: responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          if (isLoading)
            const CupertinoActivityIndicator(radius: 15) // Indicador de carga
          else if (rows.isEmpty) ...[
            Text(
              'Aún no has completado un curso',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: PaginatedTableNormal(
                columns: TableDataExampleNormal.getColumns(),
                rows: TableDataExampleNormal.getRows(),
                isLoading: false,
              ),
            )
          ] else ...[
            Text(
              'Mis cursos completados',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: PaginatedTableNormal(
                columns: columns,
                rows: rows,
                isLoading: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
