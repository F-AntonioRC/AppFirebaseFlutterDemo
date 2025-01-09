import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/pages/employee/form_body_employee.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/employee_form_logic.dart';
import 'package:testwithfirebase/service/employeeService/service_employee.dart';

class Employee extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const Employee({super.key, this.initialData});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final EmployeeFormLogic _formLogic =
      EmployeeFormLogic(); //Instancia de la lógica

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      if (provider.data != null) {
        _formLogic.initializeControllers(context, provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _formLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(
        children: [
          FormBodyEmployee(
              title: widget.initialData != null
                  ? "Editar Empleado"
                  : "Añadir Empleado",
              nameController: _formLogic.nameController,
              controllerDependency: _formLogic.controllerDependency,
              controllerArea: _formLogic.controllerArea,
              controllerSare: _formLogic.controllerSare,
              dropdownSex: _formLogic.dropdownSex,
              sexDropdownValue: _formLogic.sexDropdownValue,
              onChangedDropdownList: (String? newValue) {
                _formLogic.sexDropdownValue = newValue;
              }, controllerSection: _formLogic.controllerSection,),
          const SizedBox(height: 20.0),
          ActionsFormCheck(
            isEditing: widget.initialData != null,
            onAdd: () async {
              await addEmployee(
                  context,
                  _formLogic.nameController,
                  _formLogic.sexDropdownValue,
                  _formLogic.controllerArea,
                  _formLogic.controllerSare,
                  _formLogic.controllerDependency,
                  _formLogic.clearControllers,
                  () => _formLogic.refreshProviderData(context)
              );
            },
            onUpdate: () async {
              final String documentId = widget.initialData?['IdEmployee'];
              await updateEmployee(
                  context,
                  documentId,
                  _formLogic.nameController,
                  _formLogic.sexDropdownValue,
                  _formLogic.controllerArea,
                  _formLogic.controllerSare,
                  _formLogic.controllerDependency,
                  widget.initialData,
                  () => _formLogic.clearProviderData(context),
                  () => _formLogic.refreshProviderData(context)
               );
                  _formLogic.clearControllers();
            },
            onCancel: () {
              _formLogic.clearControllers();
              _formLogic.clearProviderData(context);
            },
          )
        ],
      ),
    ));
  }
}