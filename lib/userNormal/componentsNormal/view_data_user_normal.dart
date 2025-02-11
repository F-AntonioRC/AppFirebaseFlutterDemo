import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/formPatrts/body_widgets.dart';
import 'package:testwithfirebase/userNormal/componentsNormal/tableNormal/table_normal.dart';
class ViewDataUserNormal extends StatefulWidget {
  const ViewDataUserNormal({super.key});

  @override
  State<ViewDataUserNormal> createState() => _ViewDataUserNormalState();
}

class _ViewDataUserNormalState extends State<ViewDataUserNormal> {
  @override
  Widget build(BuildContext context) {
    return const BodyWidgets(body: TableNormal());
  }
}
