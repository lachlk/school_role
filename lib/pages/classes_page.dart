import 'package:flutter/material.dart';// Imports required packages and pages
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_grid_tile.dart';
import 'package:school_role/widgets/class_bottom_sheet.dart';

class ClassesList extends StatefulWidget {
  final String uID;

  const ClassesList({super.key, required this.uID});

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  final ClassService classService = ClassService();
  late Future<List<Map<String, String>>> futureClasses;
  final List<DraggableGridItem> draggableItems = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    loadClasses();
  }

  void loadClasses() {
    setState(() {
      draggableItems.clear();
      futureClasses = classService.getClassList(widget.uID);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void buildDraggableItems(List<Map<String, String>> classes) {
    draggableItems.clear();
    draggableItems.addAll(
      classes.map(
        (classItem) => DraggableGridItem(
          isDraggable: true,
          child: ClassGridTile(
            className: classItem['name'] ?? 'Unnamed',
            classID: classItem['id']!,
            onDelete: loadClasses,
            uID: widget.uID,
            classService: classService,
          ),
        ),
      ),
    );
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
          final controller = TextEditingController();
          final shouldRefresh = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => ClassBottomSheet(
              controller: controller,
              uID: widget.uID,
              classService: classService,
              onGetClasses: loadClasses,
            ),
          );

          if (shouldRefresh == true) loadClasses();
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
              buildDraggableItems(classes);
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
                      draggableItems..clear()..addAll(reorderedList);
                    });
                    
                    await classService.reorderClasses(reorderedList);
                  },
                  children: draggableItems,
                  isOnlyLongPress: true,
                  dragPlaceHolder: (List<DraggableGridItem> list, int index) => PlaceHolderWidget(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  dragFeedback: (list, index) {
                    final child = list[index].child;
                    if (child is ClassGridTile) {
                      final crossAxisCount = MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4;
                      final tileSize = MediaQuery.of(context).size.width / crossAxisCount -20;
                      return Material(
                        color: Colors.transparent,
                        child: Transform.scale(
                          scale: 1.1,
                          child: SizedBox(
                            width: tileSize,
                            height: tileSize,
                            child: child,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
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
