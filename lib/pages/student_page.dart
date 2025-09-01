import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/student_list.dart';
import 'package:school_role/widgets/student_page_widgets/student_bottom_sheet.dart';
import 'package:school_role/widgets/custom_app_bar.dart';
import 'package:school_role/services/class_service.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({
    super.key,
    required this.classID,
    required this.schoolID,
    required this.className,
  });

  final String classID;
  final String schoolID;
  final String className;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackTap: () => Navigator.of(context).pop(),
        title: widget.className,
      ),
      body: StudentList(
        classID: widget.classID,
        schoolID: widget.schoolID,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => StudentBottomSheet(
            classID: widget.classID,
            schoolID: widget.schoolID,
            onStudentAdded: () => setState(() {}),
            onRemove: (studentID) async {
              final classService = ClassService();
              await classService.removeStudentFromClass(
                schoolID: widget.schoolID,
                classID: widget.classID,
                studentID: studentID,
              );
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}