import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:school_role/main.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key}); // Student list widget

  @override
  State<StudentList> createState() =>
      _StudentListState(); // Creats state for student list
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    var students = [
      // List of student names
      'Emily Harrison',
      'Jacob Martinez',
      'Olivia Thompson',
      'Ethan Rodriguez',
      'Sophia Carter',
      'Noah Sullivan',
      'Ava Murphy',
      'Liam Bennett',
      'Mia Rivera',
      'Benjamin Foster',
      'Charlotte Davis',
      'James Wilson',
      'Isabella Moore',
      'Michael Turner',
      'Grace Anderson',
      'Daniel Cooper',
    ];

    return Scaffold(
      body: ListView(children: <Widget>[
      for (var student in students)
        Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              surfaceTintColor: Theme.of(context)
                  .colorScheme
                  .primary
                  .harmonizeWith(Colors.white),
              child: ListTile(
                title: Text(student), // Display student name
                trailing: const PresenceSelector(), // Dislay presence selector
              ),
            ))
    ]));
  }
}

enum Presence { present, late, absent } // Values for presence status

class PresenceSelector extends StatefulWidget {
  const PresenceSelector({super.key}); // Presence selector widget

  @override
  State<PresenceSelector> createState() =>
      _PresenceSelectorState(); // Create state for presence selector
}

class _PresenceSelectorState extends State<PresenceSelector> {
  Presence presenceView = Presence.absent; // Defualt status

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Presence>(
      // Segmented button for presence
      showSelectedIcon: false,
      segments: const <ButtonSegment<Presence>>[
        ButtonSegment<Presence>(
          value: Presence.present,
          label: Text('Present'),
          
        ),
        ButtonSegment<Presence>(
          value: Presence.late,
          label: Text('Late'),
        ),
        ButtonSegment<Presence>(
          value: Presence.absent,
          label: Text('Absent'),
        ),
      ],
      selected: <Presence>{presenceView}, // Selected presence
      onSelectionChanged: (Set<Presence> newSelection) {
        setState(() {
          presenceView = newSelection.first; // Updates presence for selected
        });
      },
    );
  }
}
