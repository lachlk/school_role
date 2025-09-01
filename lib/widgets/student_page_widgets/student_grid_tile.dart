import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/presence_selector.dart';

class StudentGridTile extends StatelessWidget {
  final Map<String, String> student;
  final ValueChanged<String> onPresenceChanged;

  const StudentGridTile({
    super.key,
    required this.student,
    required this.onPresenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListTile(
          title: Text(student['name']!),
          trailing: PresenceSelector(
            selectedPresence: student['presence'] ?? 'absent',
            onPresenceChanged: onPresenceChanged,
          ),
        ),
      ),
    );
  }
}