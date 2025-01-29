import 'package:flutter/material.dart';
import '../../util/responsive.dart';

///El componente `BodyCardDetailCourse` es un widget personalizado para mostrar los componentes de la UI
///en el `DialogEmail` sirviendo como un esquema para la visualizacion de los datos, controladores e iconos.
class BodyCardDetailCourse extends StatelessWidget {
  final TextEditingController firstController; //Controlador para el primer valor asignado.
  final String firstTitle; //Titulo para mostrar en el controlador `firstController`.
  final Icon firstIcon; //Icono para mostrar en el textfield del valor `firstController`.
  final TextEditingController secondController; //Controlador para el segundo valor asignado.
  final String secondTitle; //Titulo para mostrar en el controlador `secondController`.
  final Icon secondIcon; //Icono para mostrar en el textfield del valor `secondController`.

  const BodyCardDetailCourse({super.key,
    required this.firstController,
    required this.firstTitle,
    required this.secondController,
    required this.secondTitle,
    required this.firstIcon,
    required this.secondIcon});

  ///Construcción del widget con las propiedades del tema asignado 
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
          children: [
            //Widget para mostrar el valor del `firstTitle`
            Text(
              firstTitle,
              style: TextStyle(
                fontSize: responsiveFontSize(context, 15),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            //Widget para ver el valor del `firstController` se utiliza la propiedad readOnly en true 
            //para evitar la modificacion de los datos obtenidos.
            TextField(
              readOnly: true,
              controller: firstController,
              decoration: InputDecoration(
                prefixIcon: firstIcon,
                enabledBorder: _buildDisabledBorder(theme),
                focusedBorder: _buildDisabledBorder(theme),
              ),
            ),
          ],
        ),),
        const SizedBox(width: 10.0),
        Expanded(child: Column(
          children: [
            //Widget para mostrar el valor del `secondTitle`
            Text(
              secondTitle,
              style: TextStyle(
                fontSize: responsiveFontSize(context, 15),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            //Widget para ver el valor del `secondController` se utiliza la propiedad readOnly en true 
            //para evitar la modificacion de los datos obtenidos.
            TextField(
              readOnly: true,
              controller: secondController,
              decoration: InputDecoration(
                prefixIcon: secondIcon,
                enabledBorder: _buildDisabledBorder(theme),
                focusedBorder: _buildDisabledBorder(theme),
              ),
            ),
          ],
        ))
      ],
    );
  }
  /// Método privado dentro de la clase para crear el borde personalizado
  InputBorder _buildDisabledBorder(ThemeData theme) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: theme.hintColor),
    borderRadius: BorderRadius.circular(10.0),
  );
}
}
