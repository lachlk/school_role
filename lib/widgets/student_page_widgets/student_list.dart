import 'package:flutter/material.dart';
import 'package:school_role/models/student.dart';
import 'package:school_role/widgets/student_page_widgets/student_grid_tile.dart';
import 'package:school_role/services/student_service.dart';

/// A `StatefulWidget` that displays a list of students for a specific class.
class StudentList extends StatefulWidget {
  const StudentList({
    super.key,
    required this.classID,
    required this.schoolID,
    required this.onAttendanceChanged,
    required this.attendanceRecords,
  });

  /// The unique identifier of the class.
  final String classID;
  /// The unique identifier of the school.
  final String schoolID;
  /// Callback function to be called when a students attendance status changes.
  final Function(String studentID, String presence) onAttendanceChanged;
  /// A map containing the attendance status for each student.
  final Map<String, String> attendanceRecords;

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  // An instance of `StudentService` to interact with student data.
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    // Uses a `StreamBuilder` to listen for real-time updates to the list of students.
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

        // Builds a list of widgets from the student data.
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final presence = widget.attendanceRecords[student.id] ?? 'absent';
            return StudentGridTile(
              // Converts the student model to a map and adds the attendance status.
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