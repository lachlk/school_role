import 'package:flutter/material.dart';
import 'package:school_role/models/student.dart';
import 'package:school_role/widgets/student_page_widgets/student_grid_tile.dart';
import 'package:school_role/services/student_service.dart';

class StudentList extends StatefulWidget {
  final String classID;
  final String schoolID;
  final Function(String studentID, String presence) onAttendanceChanged;

  const StudentList({
    super.key,
    required this.classID,
    required this.schoolID,
    required this.onAttendanceChanged,
  });

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final StudentService _studentService = StudentService();
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: _studentService.streamClassStudents(widget.schoolID, widget.classID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No students found'));
        }

        final students = snapshot.data!;

        if (!_isInitialized) {
          for (final student in students) {
            widget.onAttendanceChanged(student.id, 'absent');
          }
          _isInitialized = true;
        }

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return StudentGridTile(
              student: student.toMap().map((k, v) => MapEntry(k, v.toString())),
              onPresenceChanged: (presence) {
                widget.onAttendanceChanged(student.id, presence);
              },
            );
          },
        );
      },
    );
  }
}