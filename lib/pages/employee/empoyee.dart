import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/actions_form_check.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/components/firebase_dropdown.dart';
import 'package:testwithfirebase/pages/employee/form_body_employee.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/service_employee.dart';

class Employee extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const Employee({super.key, this.initialData});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final List<String> dropdownSex = ["M", "F"];
  String? sexDropdownValue;

  final FirebaseDropdownController _controllerArea =
  FirebaseDropdownController();

  final FirebaseDropdownController _controllerSare =
  FirebaseDropdownController();

  final FirebaseDropdownController _controllerDependency =
  FirebaseDropdownController();

  final TextEditingController nameController = TextEditingController();

  bool isClearing = false;

  void _clearControllers() {
    nameController.clear();
    sexDropdownValue = null;
    _controllerArea.clearSelection();
    _controllerSare.clearSelection();
    _controllerDependency.clearSelection();
  }

  void _clearProviderData() {
    final provider = Provider.of<EditProvider>(context, listen: false);
    provider.clearData();
  }

  void _initializeControllers(EditProvider provider) {
    if (isClearing) return;
    if (provider.data != null) {
      nameController.text = provider.data?['Nombre'] ?? '';
      sexDropdownValue = provider.data?['Sexo'];
      if (provider.data?['Area'] != null) {
        _controllerArea.setDocument({
          'Id': provider.data?['IdArea'],
          'Area': provider.data?['Area']});
      }
      if (provider.data?['Dependencia'] != null) {
        _controllerDependency.setDocument({
          'Id': provider.data?['IdDependencia'],
          'Dependencia': provider.data?['Dependencia']});
      }
      if (provider.data?['Sare'] != null) {
        _controllerSare.setDocument({
          'Id': provider.data?['IdSare'],
          'Sare': provider.data?['Sare']});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      if (provider.data != null) {
        _initializeControllers(provider);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProvider>(context);
    _initializeControllers(provider);

    return BodyWidgets(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FormBodyEmployee(
                  title: widget.initialData != null
                      ? "Editar Empleado"
                      : "Añadir Empleado",
                  nameController: nameController,
                  controllerDependency: _controllerDependency,
                  controllerArea: _controllerArea,
                  controllerSare: _controllerSare,
                  dropdownSex: dropdownSex,
                  sexDropdownValue: sexDropdownValue,
                  onChangedDropdownList: (value) {
                    setState(() {
                      sexDropdownValue = value;
                    });
                  }),
              const SizedBox(height: 20.0),
              ActionsFormCheck(isEditing: widget.initialData != null,
                onAdd: () async {
                  await addEmployee(
                      context,
                      nameController,
                      sexDropdownValue,
                      _controllerArea,
                      _controllerSare,
                      _controllerDependency,
                      _clearControllers);
                },
                onUpdate: () async {
                final String documentId = widget.initialData?['IdEmployee'];
                  await updateEmployee(
                      context,
                      documentId,
                      nameController,
                      sexDropdownValue,
                      _controllerArea,
                      _controllerSare,
                      _controllerDependency,
                      widget.initialData,
                      _clearProviderData);
                  _clearControllers();
                },
                onCancel: () {
                _clearProviderData();
                _clearControllers();
                },
              )

              //_buildActionButtons(provider)
            ],
          ),
        ));
  }
}