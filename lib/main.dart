import 'package:flutter/material.dart';
import 'package:school_role/theme.dart';

void main() async {
  runApp(const MyApp());
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        leading: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Sign Out',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
      body: const StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    var students = [
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
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(student),
            trailing: const PresenceSelector(),
          ),
        )
    ]));
  }
}

enum Presence { present, late, absent }

class PresenceSelector extends StatefulWidget {
  const PresenceSelector({super.key});

  @override
  State<PresenceSelector> createState() => _PresenceSelectorState();
}

class _PresenceSelectorState extends State<PresenceSelector> {
  Presence presenceView = Presence.absent;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Presence>(
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
      selected: <Presence>{presenceView},
      onSelectionChanged: (Set<Presence> newSelection) {
        setState(() {
          presenceView = newSelection.first;
        });
      },
    );
  }
}
