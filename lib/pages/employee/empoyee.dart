import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/pages/employee/form_body_employee.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';
import 'package:testwithfirebase/service/employeeService/employee_form_logic.dart';
import 'package:testwithfirebase/service/employeeService/service_employee.dart';

  /// La clase `Employee` es un Widget que representa la pantalla de empleados, en el cual se muestra
  /// un formulario para añadir o editar empleados, junto con las acciones correspondientes para
  /// guardar, actualizar o cancelar la operación.
  ///
  /// Si se proporciona información inicial a través de [initialData], el formulario
  /// se inicializa en modo edición; de lo contrario, se asume que se agregará un nuevo empleado.

class Employee extends StatefulWidget {
  /// Datos iniciales del empleado que se desean editar. Si es `null`, se mostrará el formulario
  /// en modo "Añadir empleado".
  final Map<String, dynamic>? initialData;

  /// Constructor del widget.
  const Employee({super.key, this.initialData});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  /// Instancia de la lógica de formulario para empleados que administra los controladores
  /// y las acciones específicas del formulario.
  final EmployeeFormLogic _formLogic = EmployeeFormLogic();

  @override
  void initState() {
    super.initState();
    // Se utiliza addPostFrameCallback para ejecutar la inicialización de los controladores
    // después de que se haya renderizado el primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EditProvider>(context, listen: false);
      // Si existen datos en el provider, se inicializan los controladores con dichos datos.
      if (provider.data != null) {
        _formLogic.initializeControllers(context, provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para que el widget escuche cambios en los datos.
    final provider = Provider.of<EditProvider>(context);
    // Se vuelve a inicializar los controladores para sincronizar los datos.
    _formLogic.initializeControllers(context, provider);

    return BodyWidgets(
        body: SingleChildScrollView(
      child: Column(
        children: [
          // Se muestra el formulario con la información del empleado.
          // El título varía según se esté en modo edición o en modo agregar.
          // Tambien estan los controladores de los datos almacenados en el registro o para añadir.
          FormBodyEmployee(
            title: widget.initialData != null
                ? "Editar Empleado"
                : "Añadir Empleado",
            nameController: _formLogic.nameController,
            controllerPuesto: _formLogic.controllerPuesto,
            controllerArea: _formLogic.controllerArea,
            controllerSare: _formLogic.controllerSare,
            dropdownSex: _formLogic.dropdownSex,
            sexDropdownValue: _formLogic.sexDropdownValue,
            onChangedDropdownList: (String? newValue) {
              // Actualiza el valor del sexo al cambiar la opción del desplegable.
              _formLogic.sexDropdownValue = newValue;
            },
            onChangedFirebaseValue: (String? value) {
              // Actualiza el valor del valueFirebaseDropdown al cambiar la opción del desplegable.
              _formLogic.valueFirebaseDropdown = value;
            },
            controllerSection: _formLogic.controllerSection,
            controllerOre: _formLogic.controllerOre, emailController: _formLogic.emailController,
          ),
          const SizedBox(height: 20.0),
          // Se muestran las acciones del formulario, que varían según si se está
          // en modo edición o en modo agregar.
          ActionsFormCheck(
            isEditing: widget.initialData != null,
            onAdd: () async {
              // Llama a la función para añadir un nuevo empleado.
              await addEmployee(
                  context,
                  _formLogic.nameController,
                  _formLogic.emailController,
                  _formLogic.controllerPuesto,
                  _formLogic.controllerArea,
                  _formLogic.controllerSection,
                  _formLogic.sexDropdownValue,
                  _formLogic.controllerOre,
                  _formLogic.controllerSare,
                  _formLogic.clearControllers,
                  () => _formLogic.refreshProviderData(context)
              );
            },
            onUpdate: () async {
              // Se obtiene el identificador del empleado a editar.
              final String documentId = widget.initialData?['IdEmpleado'];
              // Llama a la función para actualizar el empleado con la información proporcionada.
              await updateEmployee(
                  context,
                  documentId,
                  _formLogic.nameController,
                  _formLogic.emailController,
                  _formLogic.controllerPuesto,
                  _formLogic.controllerArea,
                  _formLogic.controllerSection,
                  _formLogic.sexDropdownValue,
                  _formLogic.controllerOre,
                  _formLogic.controllerSare,
                  widget.initialData,
                  // Limpia los datos que vienen del provider.
                  () => _formLogic.clearProviderData(context),
                  // Actualiza la parte de la UI con los registros de los cursos.
                  () => _formLogic.refreshProviderData(context));
              // Limpia los controladores después de la actualización.
              _formLogic.clearControllers();
            },
            onCancel: () {
              // Limpia los controladores y los datos del provider en caso de cancelación
              _formLogic.clearControllers();
              _formLogic.clearProviderData(context);
            },
          )
        ],
      ),
    ));
  }
}
