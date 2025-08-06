import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:testwithfirebase/components/formPatrts/actions_form_check.dart';
import 'package:testwithfirebase/components/formPatrts/custom_snackbar.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/service/usersService/database_methods_users.dart';

  //La clase `DialogDeleteUsers` se encarga de mostrar los datos del usuario para la eliminación
  //definitiva de la base de datos
class DialogDeleteUsers extends StatefulWidget {
  final String
      uidChange; //Un `String` que representa el uid del usuario seleccionado.
  final String cupo; //Un `String` que representa el CUPO único del empleado.
  final Function()
      refreshTable; //Una función (`Function()`) que se ejecuta para refrescar

  const DialogDeleteUsers(
      {super.key,
      required this.uidChange,
      required this.cupo,
      required this.refreshTable});

  @override
  State<DialogDeleteUsers> createState() => _DialogDeleteUsersState();
}

class _DialogDeleteUsersState extends State<DialogDeleteUsers> {
  // Controladores para los campos del diálogo
  late TextEditingController _uidChange;
  late TextEditingController _cupo;

  @override
  void initState() {
    super.initState();
    _uidChange = TextEditingController(text: widget.uidChange);
    _cupo = TextEditingController(text: widget.cupo);
  }

  /// Limpieza de recursos: Libera los controladores para evitar fugas de memoria.
  @override
  void dispose() {
    _uidChange.dispose();
    _cupo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text(
        'Eliminar Usuario',
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text('ESTA ACCIÓN ELIMINARÁ PERMANENTEMENTE LOS REGISTROS EN CURSOS COMPLETADOS Y USER', 
            style: TextStyle(fontWeight: FontWeight.bold),),            const SizedBox(height: 15.0),
            const Text('Para eliminar un Usuario debe seguir los siguientes pasos: \n 1.- Identificar los Registros que no estan en el Módulo Empleados, no tienen Cursos Completados o estan duplicados \n 2.- Copiar el UID del usuario de este dialogo y buscarlo en FIREBASE Authentication \n ES IMPORTANTE EL SEGUNDO PASO PARA NO TENER VARIOS REGISTROS DUPLICADOS O BORRAR UN USUARIO QUE ES CORRECTO'),
            const SizedBox(height: 15.0),
            const Text("CUPO del Usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            TextField(
                readOnly: true,
                controller: _cupo,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
            const SizedBox(height: 10.0),
                        const Text("Clave UID del Usuario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            TextField(
                readOnly: true,
                controller: _uidChange,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
          ],
        ),
      ),
      actions: [
        Center(
          child: ActionsFormCheck(isEditing: true, 
          onCancel: () => Navigator.pop(context),
          onUpdate: () async {
              try {
              await DatabaseMethodsUsers().deleteuser(widget.uidChange);
              if(context.mounted) {
                showCustomSnackBar(context, 'Usuario Eliminado Correctamente', greenColorDark);
              }
              widget.refreshTable;
              } catch (e, stracktrace) {
                Sentry.captureException(
                  e,
                  stackTrace: stracktrace,
                  withScope: (scope) {
                    scope.setTag('Error_Widget_AssignCupoDialog', widget.uidChange);
                  }
                );
              }
            },),
        )
      ],
    );
  }
}
