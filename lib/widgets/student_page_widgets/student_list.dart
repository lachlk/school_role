import 'package:flutter/material.dart';
import 'package:school_role/models/student.dart';
import 'package:school_role/widgets/student_page_widgets/student_grid_tile.dart';
import 'package:school_role/services/student_service.dart';

class StudentList extends StatelessWidget {
  const StudentList({
    super.key,
    required this.classID,
    required this.schoolID,
  });

  final String classID;
  final String schoolID;

  @override
  Widget build(BuildContext context) {
    final StudentService studentService = StudentService();

    return StreamBuilder<List<Student>>(
      stream: studentService.streamClassStudents(schoolID, classID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data!;
        if (students.isEmpty) {
          return const Center(child: Text('No students found'));
        }

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final studentDataWithPresence = Map<String, dynamic>.from(student.toMap());
            studentDataWithPresence['presence'] = 'present'; 

            return StudentGridTile(
              student: studentDataWithPresence.map((k, v) => MapEntry(k, v.toString())),
            );
          },
        );
      },
    );
  }
}