import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/presence_selector.dart';

/// A `StatefulWidget` that displays a student's name and allows for changing
/// their presence status.
class StudentGridTile extends StatefulWidget {
  const StudentGridTile({
    super.key,
    required this.student,
    required this.onPresenceChanged,
  });

  /// A map containing the students data including their name and current presence status.
  /// The map keys are expected to be 'name' and 'presence'.
  final Map<String, String> student;
  final ValueChanged<String> onPresenceChanged;

  @override
  State<StudentGridTile> createState() => _StudentGridTileState();
}

class _StudentGridTileState extends State<StudentGridTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ListTile(
          title: Text(widget.student['name']!),
          trailing: PresenceSelector(
            selectedPresence: widget.student['presence'] ?? 'absent',
            onPresenceChanged: widget.onPresenceChanged,
          ),
        ),
      ),
    );
  }
}