import 'package:flutter/material.dart';
import '../dataConst/constand.dart';

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
