import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/presence_selector.dart';

class StudentGridTile extends StatelessWidget {
  const StudentGridTile({super.key, required this.student});

  final Map<String, String> student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListTile(
          title: Text(student['name']!), // Display student name
          trailing: PresenceSelector(selectedPresence: student['presence']!), // Display presence selector
        ),
      ),
    );
  }
}
