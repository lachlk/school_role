import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/main.dart'; // Imports required packages and pages
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> getClassList(String uID) async {
    final QuerySnapshot result = await db
        .collection('classes')
        .where('userID', arrayContains: uID)
        .get();

    return result.docs.map((doc) => {
      'id': doc.id,
      'name': doc.get('name') as String,
    }).toList();
  }

  Future<void> addClass(String name, String uID) async {
    final data = {
      'name': name,
      'userID': [uID],
    };
    await db.collection('classes').add(data);
  }

  Future<void> deleteClass(String classID) async {
    await db.collection('classes').doc(classID).delete();
  }
}

class ClassesList extends StatefulWidget {
  final String uID;

  const ClassesList({super.key, required this.uID});

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  late Future<List<Map<String, String>>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = FirebaseService().getClassList(widget.uID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController controller = TextEditingController();

          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) {
              return ClassBottomSheet(
                uID: widget.uID,
                controller: controller,
                onGetClasses: () {
                  setState(() {
                    futureClasses = FirebaseService().getClassList(widget.uID);
                  });
                },
              );
            },
          ); // Floating action button for future use
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
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
                  final classItem = classes[index];
                  final className = classItem['name']!;
                  final classID = classItem['id']!;
                  return ClassGridTile(
                    key: ValueKey(classID),
                    className: className,
                    classID: classID,
                    uID: widget.uID,
                    onDelete: () {
                      setState(() {
                        futureClasses = FirebaseService()
                            .getClassList(widget.uID);
                      });
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ClassGridTile extends StatefulWidget {
  const ClassGridTile({super.key, required this.className, required this.classID, required this.uID, this.onDelete});
  final String className;
  final String classID;
  final String uID;
  final VoidCallback? onDelete;

  @override
  State<ClassGridTile> createState() => _ClassGridTileState();
}

class _ClassGridTileState extends State<ClassGridTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        // Detects clicking of the card
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                ThirdRoute(classID: widget.classID),
            ),
          );
        },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 1,
          surfaceTintColor: Theme.of(context)
              .colorScheme
              .primary
              .harmonizeWith(Colors.white),
          child: GridTile(
            header: Align(
              alignment: Alignment.topRight,
              child: CascadingMenu(
                classID: widget.classID,
                onDelete: widget.onDelete ?? () {
                  setState(() {
                    FirebaseService().getClassList(widget.uID);
                  });
                },
              ),
            ),
            footer: GridTileBar(
              title: Text(
                widget.className,
                textAlign: TextAlign.center,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.groups,
                    color: Theme.of(context).colorScheme.outline),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClassBottomSheet extends StatefulWidget {
  const ClassBottomSheet({super.key, required this.controller, required this.uID, required this.onGetClasses});
  final String uID;
  final TextEditingController controller;
  final VoidCallback onGetClasses;

  @override
  State<ClassBottomSheet> createState() => _ClassBottomSheetState();
}

class _ClassBottomSheetState extends State<ClassBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Class Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (context, value, child) {
                  final isEnabled = value.text.isNotEmpty;
                  return TextButton(
                    onPressed: isEnabled
                        ? () async {
                            final name = widget.controller.text.trim();
                            FirebaseService()
                                .addClass(name, widget.uID);
                            widget.onGetClasses();
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text("Submit"),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CascadingMenu extends StatefulWidget {
  final String classID;
  final VoidCallback onDelete;
  const CascadingMenu({super.key, required this.classID, required this.onDelete});

  @override
  State<CascadingMenu> createState() => _CascadingMenuState();
}

class _CascadingMenuState extends State<CascadingMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Class'),
              content: const Text('Are you sure you want to delete this class?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    FirebaseService().deleteClass(widget.classID);
                    widget.onDelete();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
          child: Text('Delete'),
        ),
        const MenuItemButton(
          leadingIcon: Icon(Icons.adjust),
          onPressed: null,
          child: Text('Move'),
        ),
      ],
      builder: (context, controller, child) =>
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            color: Theme.of(context).colorScheme.outline, // Icon color based on dark or light mode
          ),
    );
  }
}