import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/main.dart'; // Imports required packages and pages
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class ClassesDatabaseService {// Query's class names
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> getClassList(uID) async {
    
    List<String> classes = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('classes')
        .where('userID', arrayContains: uID)
        .get();

    for (var eachResult in result.docs) {
      classes.add(eachResult.get('name') as String);
    }
    return classes;
  }
}

class ClassesList extends StatefulWidget {
  final String uID;

  const ClassesList({super.key, required this.uID});

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  late Future<List<String>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = ClassesDatabaseService().getClassList(widget.uID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureClasses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading classes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No classes found'));
        } else {
          var classes = snapshot.data!;
          return Scrollbar(
            // Widget for scrollbar
            thickness: 10,
            radius: const Radius.circular(5),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4),
              itemCount: classes.length,
              itemBuilder: (BuildContext context, int index) {
                String className = classes[index];
                return Card(
                  // Card for the packground of each class
                  margin: const EdgeInsets.all(10),
                  elevation: 1,
                  surfaceTintColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .harmonizeWith(Colors.white),
                  child: GestureDetector(
                    // Detects clicking of the card
                    onTap: () async {// Query's docID that matches selected name
                      final QuerySnapshot classSnapshot = await FirebaseFirestore.instance
                        .collection('classes')
                        .where('userID', arrayContains: widget.uID)
                        .where('name', isEqualTo: className)
                        .get();

                      if (classSnapshot.docs.isNotEmpty) {

                        String classID = classSnapshot.docs.first.id;//Saves docID as variable

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(//  passes classID through route
                              builder: (context) => ThirdRoute(classID: classID),
                            ),
                          );
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(Icons.groups,
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(className),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
