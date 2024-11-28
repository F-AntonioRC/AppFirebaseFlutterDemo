import 'package:flutter/cupertino.dart';
import 'package:testwithfirebase/components/detailCourses/card_detailCourse.dart';
import 'package:testwithfirebase/pages/send_email.dart';

class PageEmail extends StatelessWidget {
  const PageEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: SendEmail()),
        Expanded(child: CardDetailCourse())
      ],
    );
  }
}
