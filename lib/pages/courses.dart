import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:testwithfirebase/components/custom_snackbar.dart';
import 'package:testwithfirebase/components/date_textflied.dart';
import 'package:testwithfirebase/components/my_textfileld.dart';
import 'package:testwithfirebase/service/database_courses.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController linkCourseController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Course",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: [
            const Text(
              "Name of course",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            MyTextfileld(
                hindText: "Enter the course",
                icon: const Icon(Icons.fact_check_sharp),
                controller: nameCourseController,
                obsecureText: false,
                keyboardType: TextInputType.text),
            const SizedBox(height: 10.0),
            const Text("Link",  textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),),
            const SizedBox(height: 10.0),
            MyTextfileld(
                hindText: "Link of the course",
                icon: const Icon(Icons.link),
                controller: linkCourseController,
                obsecureText: false,
                keyboardType: TextInputType.url),
            const SizedBox(height: 10.0),
            const Text("Date of init the course",  textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),),
            const SizedBox(height: 10.0),
            DateTextField(controller: dateController),
            const SizedBox(height: 10.0),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  iconAlignment: IconAlignment.start,
                  onPressed: () async {
                  try {
                  String id = randomAlphaNumeric(3);
                  Map<String, dynamic> courseInfoMap = {
                    "Id" : id,
                    "NameCourse": nameCourseController.text,
                    "LinkCourse": linkCourseController.text,
                    "DateCourse": dateController.text
                  };
                  await MethodsCourses().addCourse(courseInfoMap, id);
                  showCustomSnackBar(context, "Course added :D");
                  } catch (e) {
                  showCustomSnackBar(context, "Error: $e");
                  }
                  }, label: const Text("Add", style: TextStyle(color: Colors.white),),),
            )
          ],
        ),
      ),
    ));
  }
}
