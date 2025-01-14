import 'package:flutter/material.dart';
import 'package:testwithfirebase/dataConst/constand.dart';
import 'package:testwithfirebase/util/responsive.dart';

class HeaderGraphics extends StatelessWidget {
  final String title;
  final VoidCallback onToggleView;
  final bool viewOtherGraphics;
  final String viewOn;
  final String viewOff;

  const HeaderGraphics(
      {super.key,
      required this.title,
      required this.onToggleView,
      required this.viewOtherGraphics,
      required this.viewOn,
      required this.viewOff});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold),
            )),
        Expanded(
            flex: 2,
            child: Ink(
              decoration: const ShapeDecoration(
                  shape: CircleBorder(), color: ligthBackground),
              child: IconButton(
                onPressed: onToggleView,
                tooltip: viewOtherGraphics ? viewOff : viewOn,
                icon: Icon(viewOtherGraphics
                    ? Icons.change_circle_outlined
                    : Icons.change_circle_outlined),
              ),
            ))
      ],
    );
  }
}
