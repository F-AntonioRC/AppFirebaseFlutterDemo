import 'package:flutter/cupertino.dart';

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
