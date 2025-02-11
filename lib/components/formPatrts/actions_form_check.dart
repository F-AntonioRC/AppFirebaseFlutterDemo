import 'package:flutter/material.dart';
import '../../dataConst/constand.dart';
import 'my_button.dart';
/// La clase `ActionsFormCheck` es un StatelessWidget en dart que recibe como parametros:
/// isEditing tipo bool, onAdd tipo VoidCallback, onUpdate tipo VoidCallback y onCancel tipo VoidCallback.
class ActionsFormCheck extends StatelessWidget {
  final bool isEditing;
  final VoidCallback? onAdd;
  final VoidCallback? onUpdate;
  final VoidCallback? onCancel;

  const ActionsFormCheck({super.key,
    required this.isEditing,
    this.onAdd,
    this.onUpdate,
    this.onCancel});

/// La construcción del componente se realiza mediante un row donde los elementos estan alineados 
/// de manera centrica, dentro del row esta el componente MyButton reutilizado para poder realizar 
/// diversas acciones, usando como valor para mostrar los elementos el parametro isEditing.
/// Se muestran de manera condicional según el valor de la variable `isEditing`. Si `isEditing` es falso, se muestra un
/// widget `MyButton` con el texto 'Agregar'. Si `isEditing` es verdadero, se muestran dos widgets `MyButton`
/// con el texto 'Aceptar'
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isEditing)
            MyButton(
              text: 'Agregar',
              icon: const Icon(Icons.person_add_alt_rounded),
              onPressed: onAdd,
              buttonColor: greenColorLight,
            ),
          if (isEditing) ...[
            MyButton(
              text: 'Aceptar',
              icon: const Icon(Icons.check_circle_outline),
              onPressed: onUpdate,
              buttonColor: greenColorLight,
            ),
            const SizedBox(
              width: 10.0,
            ),
            MyButton(
              text: "Cancelar",
              icon: const Icon(Icons.cancel_outlined),
              buttonColor: wineLight,
              onPressed: onCancel,
            )
          ],
        ],
      ),
    );
  }
}
