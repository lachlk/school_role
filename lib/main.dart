import 'package:flutter/material.dart';
import 'package:school_role/theme.dart'; // Imports the required packages and files

void main() async {
  runApp(const MyApp()); // Start of the application
}

class Header extends StatelessWidget {
  const Header({super.key}); // Header widget for app header

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // Shadow elevation
        shadowColor: Colors.black, // Shadow color
        toolbarHeight: 80, // Height of the app bar
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))), // Custom shape for appbar
        leading: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          color: Theme.of(context).colorScheme.onPrimary, // Icon color based on dark or light mode
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Sign Out',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary), // Text color based on dark or light mode
              ),
            ),
          ),
        ],
      ),
      body: const StudentList(), // Displays the student list
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({super.key}); // Student list widget

  @override
  State<StudentList> createState() => _StudentListState(); // Creats state for student list
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    var students = [ // List of student names
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
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(student), // Display student name
            trailing: const PresenceSelector(), // Dislay presence selector
          ),
        )
    ]));
  }
}

enum Presence { present, late, absent } // Values for presence status

class PresenceSelector extends StatefulWidget {
  const PresenceSelector({super.key}); // Presence selector widget

  @override
  State<PresenceSelector> createState() => _PresenceSelectorState(); // Create state for presence selector
}

class _PresenceSelectorState extends State<PresenceSelector> {
  Presence presenceView = Presence.absent; // Defualt status

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Presence>( // Segmented button for presence
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
