import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testwithfirebase/components/detailCourses/card_detailCourse.dart';
import 'package:testwithfirebase/pages/detailCourses/detail_courses.dart';
import 'package:testwithfirebase/providers/edit_provider.dart';

class PageDetailCourses extends StatefulWidget {
  const PageDetailCourses({super.key});

  @override
  State<PageDetailCourses> createState() => _PageDetailCoursesState();
}

class _PageDetailCoursesState extends State<PageDetailCourses> {
  @override
  Widget build(BuildContext context) {
    final detailCoursesProvider = Provider.of<EditProvider>(context);

    return Column(
      children: [
        Expanded(
            child: DetailCourses(
          initialData: detailCoursesProvider.data,
        )),
        const Expanded(child: CardDetailCourse())
      ],
    );
  }
}
