import 'package:flutter/material.dart';
import '../../dataConst/constand.dart';
import 'my_button.dart';

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
              buttonColor: greenColor,
            ),
          if (isEditing) ...[
            MyButton(
              text: 'Aceptar',
              icon: const Icon(Icons.check_circle_outline),
              onPressed: onUpdate,
              buttonColor: greenColor,
            ),
            const SizedBox(
              width: 10.0,
            ),
            MyButton(
              text: "Cancelar",
              icon: const Icon(Icons.cancel_outlined),
              buttonColor: Colors.red,
              onPressed: onCancel,
            )
          ],
        ],
      ),
    );
  }
}
