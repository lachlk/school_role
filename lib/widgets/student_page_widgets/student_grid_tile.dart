import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/presence_selector.dart';

class StudentGridTile extends StatefulWidget {
  final Map<String, String> student;
  final ValueChanged<String> onPresenceChanged;

  const StudentGridTile({
    super.key,
    required this.student,
    required this.onPresenceChanged,
  });

  @override
  State<StudentGridTile> createState() => _StudentGridTileState();
}

class _StudentGridTileState extends State<StudentGridTile> {
  late String _selectedPresence;

  @override
  void initState() {
    super.initState();
    _selectedPresence = 'absent';
  }

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
            selectedPresence: _selectedPresence,
            onPresenceChanged: (newPresence) {
              setState(() {
                _selectedPresence = newPresence;
              });
              widget.onPresenceChanged(newPresence);
            },
          ),
        ),
      ),
    );
  }
}