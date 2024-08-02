import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class StudentsDatabaseService extends StatelessWidget {
  StudentsDatabaseService({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> getStudentIDList(String classID) async {
    List<String> studentIDs = [];

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('attendance')
        .where('classID', isEqualTo: classID)
        .get();

    for (var eachResult in result.docs) {
      Map<String, dynamic> presence = eachResult.get('presence');
      presence.forEach((key, value) {
        if (!studentIDs.contains(key)) {
          studentIDs.add(key);
        }
      });
    }
    return studentIDs;
  }

  Future<List<String>> getStudentList(String classID) async {
    List<String> studentIDs = await getStudentIDList(classID);
    List<String> students = [];

    for (var studentID in studentIDs) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('students')
          .where(FieldPath.documentId, isEqualTo: studentID)
          .get();
  
      for (var eachResult in result.docs) {
        students.add(eachResult.get('name') as String);
      }
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StudentList extends StatefulWidget {
  final String classID;

  const StudentList({super.key, required this.classID}); // Student list widget

  @override
  State<StudentList> createState() => _StudentListState(); // Creats state for student list
}

class _StudentListState extends State<StudentList> {
  late Future<List<String>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = StudentsDatabaseService().getStudentList(widget.classID);
  }

  @override

  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: futureStudents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading students'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No students found'));
        } else {
          var students = snapshot.data!;
          return Scrollbar(
            thickness: 10,
            radius: const Radius.circular(5),
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, student) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    surfaceTintColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .harmonizeWith(Colors.white),
                    child: ListTile(
                      title: Text(students[student]), // Display student name
                      trailing:
                          const PresenceSelector(), // Dislay presence selector
                    ),
                  ),
                );
              },
            ),
          );
        }
      }
    );
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
        setState(
          () {
            presenceView = newSelection.first; // Updates presence for selected
          },
        );
      },
    );
  }
}
