import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/body_widgets.dart';
import 'package:testwithfirebase/graphics/data/line_chart_sample2.dart';
import 'package:testwithfirebase/util/responsive.dart';
class CardGraphicsNormal extends StatefulWidget {
  const CardGraphicsNormal({super.key});

  @override
  State<CardGraphicsNormal> createState() => _CardGraphicsNormalState();
}

class _CardGraphicsNormalState extends State<CardGraphicsNormal> {
  @override
  Widget build(BuildContext context) {
    return BodyWidgets(body: SingleChildScrollView(
      child:  Column(
        children: [
          Text('Aqui podras ver las graficas con los datos de tus cursos',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold
              )),
          Text('Aun no tienes datos disponibles',
              style: TextStyle(
                  fontSize: responsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold
              )),
          const LineChartSample2()
        ],
      ),
    ));
  }
}

