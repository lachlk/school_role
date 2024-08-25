import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class StudentsDatabaseService extends StatelessWidget {// Query's student Ids and Presences in class
  StudentsDatabaseService({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getStudentIDList(String classID) async {
    Map<String, dynamic> studentIDs = {};

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('attendance')
        .where('classID', isEqualTo: classID)
        .get();

    for (var eachResult in result.docs) {
      final presence = eachResult.get('presence');
      studentIDs.addAll(presence);
    }
    return studentIDs;
  }

  Future<List<Map<String, String>>> getStudentList(String classID) async {// Query's the students names that match id
    Map<String, dynamic> studentIDs = await getStudentIDList(classID);
    if (studentIDs.isEmpty) return [];

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('students')
        .where(FieldPath.documentId, whereIn: studentIDs.keys.toList())
        .get();
    
    return result.docs.map((doc) {
      return {
        'name': doc.get('name') as String,
        'presence': studentIDs[doc.id] as String,
      };
    }).toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
    futureStudents = StudentsDatabaseService().getStudentList(widget.classID);
  }

  @override

  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
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
              itemBuilder: (BuildContext context, index) {
                String studentName = students[index]['name']!;
                String selectedPresence = students[index]['presence']!;
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    surfaceTintColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .harmonizeWith(Colors.white),
                    child: ListTile(
                      title: Text(studentName), // Display student name
                      trailing:
                        PresenceSelector(selectedPresece: selectedPresence), // Dislay presence selector
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

enum Presence {
  present('present'), late('late'), absent('absent');

  const Presence(this.value);
  final String value;
} // Values for presence status

class PresenceSelector extends StatefulWidget {
  final String selectedPresece;
  
  const PresenceSelector({super.key, required this.selectedPresece}); // Presence selector widget

  @override
  State<PresenceSelector> createState() =>
      _PresenceSelectorState(); // Create state for presence selector
}

class _PresenceSelectorState extends State<PresenceSelector> {
  // Presence presenceView = Presence.absent; // Defualt status
  late Presence presenceView = Presence.values.byName(widget.selectedPresece);

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
