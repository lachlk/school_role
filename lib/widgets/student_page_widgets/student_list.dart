import 'package:flutter/material.dart';
import 'package:school_role/services/student_service.dart';
import 'package:school_role/widgets/student_page_widgets/student_grid_tile.dart';

class StudentList extends StatefulWidget {
  final String classID;

  const StudentList({super.key, required this.classID}); // Student list widget

  @override
  State<StudentList> createState() => _StudentListState(); // Creats state for student list
}

class _StudentListState extends State<StudentList> {
  late Future<List<Map<String, String>>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = StudentService().getStudentList(widget.classID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: futureStudents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading students: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No students found'));
        } else {
          var students = snapshot.data!;
          return SafeArea(
            child: Scrollbar(
              thickness: 10,
              radius: const Radius.circular(5),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, index) {
                  Map<String, String> student = students[index];
                  return StudentGridTile(student: student);
                },
              ),
            ),
          );
        }
      }
    );
  }
}
