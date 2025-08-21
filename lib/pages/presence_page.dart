import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:school_role/services/student_service.dart';

class StudentList extends StatefulWidget {
  final String classID;

  const StudentList({super.key, required this.classID}); // Student list widget

  @override
  State<StudentList> createState() => _StudentListState(); // Creats state for student list
}

class _StudentListState extends State<StudentList> {
  late Future<List<Map<String, String>>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = StudentService().getStudentList(widget.classID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, String>>>(
        future: futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading students: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          } else {
            var students = snapshot.data!;
            return Scrollbar(
              thickness: 10,
              radius: const Radius.circular(5),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, index) {
                  Map<String, String> student = students[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      surfaceTintColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .harmonizeWith(Colors.white),
                      child: ListTile(
                        title: Text(student['name']!), // Display student name
                        trailing:
                          PresenceSelector(selectedPresence: student['presence']!), // Dislay presence selector
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () async {},
      ),
    );
  }
}

enum Presence {
  present('present'), late('late'), absent('absent');

  const Presence(this.value);
  final String value;
} // Values for presence status

class PresenceSelector extends StatefulWidget {
  final String selectedPresence;
  const PresenceSelector({super.key, required this.selectedPresence}); // Presence selector widget

  @override
  State<PresenceSelector> createState() =>
      _PresenceSelectorState(); // Create state for presence selector
}

class _PresenceSelectorState extends State<PresenceSelector> {
  // Presence presenceView = Presence.absent; // Defualt status
  late Presence presenceView;

  @override
  void initState() {
    super.initState();
    presenceView = Presence.values.firstWhere(
      (p) => p.value == widget.selectedPresence,
      orElse: () => Presence.absent,
    );
  }

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
      selected: {presenceView}, // Selected presence
      onSelectionChanged: (newSelection) {
        setState(() {
          presenceView = newSelection.first; // Updates presence for selected
        });
      },
    );
  }
}
