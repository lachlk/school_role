import 'package:flutter/material.dart';
import 'package:school_role/models/student.dart';
import 'package:school_role/widgets/student_page_widgets/student_grid_tile.dart';
import 'package:school_role/services/student_service.dart';

class StudentList extends StatefulWidget {
  final String classID;
  final String schoolID;
  final Function(String studentID, String presence) onAttendanceChanged;
  final Map<String, String> attendanceRecords;

  const StudentList({
    super.key,
    required this.classID,
    required this.schoolID,
    required this.onAttendanceChanged,
    required this.attendanceRecords,
  });

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: _studentService.streamClassStudents(widget.schoolID, widget.classID),
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
            final presence = widget.attendanceRecords[student.id] ?? 'absent';
            return StudentGridTile(
              student: student.toMap().map((k, v) => MapEntry(k, v.toString()))..['presence'] = presence,
              onPresenceChanged: (newPresence) {
                widget.onAttendanceChanged(student.id, newPresence);
              },
            );
          },
        );
      },
    );
  }
}