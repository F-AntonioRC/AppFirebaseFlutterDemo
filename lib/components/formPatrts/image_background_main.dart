import 'package:flutter/cupertino.dart';

  /// La clase `ImageBackgroundMain` representa una imagen estatica de los recursos para mostrar en
  /// diferentes componentes del código, esta envuelta en un SizedBox con la propiedad BoxFit.contain,
  /// para que se adapte al tamaño que se le sea asignado.
class ImageBackgroundMain extends StatelessWidget {
  const ImageBackgroundMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset('assets/images/logoActualizado.jpg',
      fit: BoxFit.contain,
      ),
    );
  }
}
