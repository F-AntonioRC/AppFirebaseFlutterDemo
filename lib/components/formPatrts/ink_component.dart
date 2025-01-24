import 'package:flutter/material.dart';
import '../../dataConst/constand.dart';

/// La clase `InkComponent` es un StatefulWidget en dart que recibe como parametros:
/// tooltip tipo String, icon tipo Icon, y inkFuncion tipo VoidCallback.
class InkComponent extends StatefulWidget {
  final String tooltip;
  final Icon iconInk;
  final VoidCallback inkFunction;

  const InkComponent(
      {super.key,
      required this.tooltip,
      required this.iconInk,
      required this.inkFunction});

  @override
  State<InkComponent> createState() => _InkComponentState();
}

/// La construcción del componente se realiza con una decoración estatica de un color establecido
/// y la utilización de los parametros como valores dinamicos dependiendo del uso.
/// El componente ink tiene un child (hijo) de tipo IconButton.
class _InkComponentState extends State<InkComponent> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(shape: CircleBorder(), color: ligth),
      child: IconButton(onPressed: widget.inkFunction, icon: widget.iconInk,
      tooltip: widget.tooltip,
      ),
    );
  }
}
