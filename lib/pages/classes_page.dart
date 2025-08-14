import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/main.dart'; // Imports required packages and pages
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> getClassList(String uID) async {
    final QuerySnapshot result = await db
      .collection('classes')
      .where('userID', arrayContains: uID)
      .orderBy('order')
      .get();

    return result.docs.map((doc) => {
      'id': doc.id,
      'name': doc.get('name') as String,
    }).toList();
  }

  Future<void> addClass(String name, String uID) async {
    final classes = await db
      .collection('classes')
      .where('userID', arrayContains: uID)
      .get();

    final newOrder = classes.size;

    final data = {
      'name': name,
      'userID': [uID],
      'order': newOrder,
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
  List<DraggableGridItem> draggableItems = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    futureClasses = FirebaseService().getClassList(widget.uID);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void refreshClasses() {
  setState(() {
    draggableItems.clear();
    futureClasses = FirebaseService().getClassList(widget.uID);
  });
}

  void _buildDraggableItems(List<Map<String, String>> classes) {
    draggableItems = classes
      .map((classItem) => DraggableGridItem(
        isDraggable: true,
        child: ClassGridTile(
          className: classItem['name'] ?? 'Unnamed',
          classID: classItem['id']!,
          onDelete: refreshClasses,
          uID: widget.uID,
        ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final shouldRefresh = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => ClassBottomSheet(
              uID: widget.uID,
              controller: TextEditingController(),  
              onGetClasses: refreshClasses,
            ),
          );

          if (shouldRefresh == true) {
            refreshClasses();
          }
        },
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: futureClasses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading classes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No classes found'));
          } else {
            final classes = snapshot.data!;
            if (draggableItems.isEmpty) {
              _buildDraggableItems(classes);
            }
            return SafeArea(
              child: Scrollbar(
                // Widget for scrollbar
                controller: scrollController,
                thickness: 10,
                radius: const Radius.circular(5),
                child: DraggableGridViewBuilder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4,
                  ),
                  dragCompletion: (reorderedList, int beforeIndex, int afterIndex) async {
                    setState(() {
                      draggableItems = reorderedList;
                    });

                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    for (int i = 0; i < draggableItems.length; i++) {
                      final classTile = draggableItems[i].child as ClassGridTile;
                      final classDocRef = FirebaseFirestore.instance
                        .collection('classes')
                        .doc(classTile.classID);
                      batch.update(classDocRef, {'order': i});
                    }
                    await batch.commit();
                  },
                  children: draggableItems,
                  isOnlyLongPress: true,
                  dragPlaceHolder: (List<DraggableGridItem> list, int index) {
                    return PlaceHolderWidget(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  dragFeedback: (list, index) {
                    final child = list[index].child;
                    if (child is ClassGridTile) {
                      final tile = child;
                      final crossAxisCount = MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4;
                      final tileSize = MediaQuery.of(context).size.width / crossAxisCount -20;
                      return Material(
                        color: Colors.transparent,
                        child: Transform.scale(
                          scale: 1.1,
                          child: SizedBox(
                            width: tileSize,
                            height: tileSize,
                            child: ClassGridTile(
                              key: ValueKey('feedback-${tile.classID}'),
                              className: tile.className,
                              classID: tile.classID,
                              uID: widget.uID,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
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
          elevation: 2,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.groups,
                    color: Theme.of(context).colorScheme.onSurface),
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
                        await FirebaseService().addClass(name, widget.uID);
                        widget.onGetClasses();
                        Navigator.of(context).pop(true);
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
            color: Theme.of(context).colorScheme.onSurface, // Icon color based on dark or light mode
          ),
    );
  }
}