import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/employee/card_employee.dart';
import 'package:testwithfirebase/pages/employee/empoyee.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/database_methods_employee.dart';

  /// Pantalla principal para la sección de empleados.
  ///
  /// Este widget es un [StatefulWidget] que organiza la interfaz de la sección de empleados,
  /// mostrando el formulario de empleados y una PaginatedTable con los registros de la colección.
  /// Utiliza un [Provider] para acceder a un [EditProvider] que contiene los registros que se deben
  /// editar o visualizar.

class ScreenEmployee extends StatefulWidget {
  const ScreenEmployee({super.key});

  @override
  State<ScreenEmployee> createState() => _ScreenEmployeeState();
}

class _ScreenEmployeeState extends State<ScreenEmployee> {
  final DatabaseMethodsEmployee databaseMethods = DatabaseMethodsEmployee();
  
  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para acceder a la información de edición de empleados.
    final employeeProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        // Área donde se muestra el formulario de los empleados.
        Expanded(
            child: Employee(
          initialData: employeeProvider.data, // Se pasa la información inicial del provider si existe.
        )),
        // Área que muestra una PaginatedTable con la información de empleados.
        const Expanded(child: CardEmployee())
      ],
    );
  }
}
