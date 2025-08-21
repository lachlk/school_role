import 'package:flutter/material.dart';// Imports required packages and pages
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_page_widgets/class_grid_tile.dart';

class ClassesList extends StatefulWidget {
  const ClassesList({
    super.key,
    required this.uID,
    required this.classService,
    required this.onRefresh,
  });

  final String uID;
  final ClassService classService;
  final VoidCallback onRefresh;

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  late Future<List<Map<String, String>>> futureClasses;
  final List<DraggableGridItem> draggableItems = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    futureClasses = widget.classService.getClassList(widget.uID);
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
            onDelete: widget.onRefresh,
            uID: widget.uID,
            classService: widget.classService,
            onRefresh: widget.onRefresh,
            onUpdate: updateClassTile,
          ),
        ),
      ),
    );
  }

  void updateClassTile(String classId, String newName) {
    final index = draggableItems.indexWhere(
      (item) => (item.child as ClassGridTile).classID == classId,
    );
    if (index != -1) {
      setState(() {
        draggableItems[index] = DraggableGridItem(
          isDraggable: true,
          child: ClassGridTile(
            className: newName,
            classID: classId,
            onDelete: widget.onRefresh,
            onRefresh: widget.onRefresh,
            uID: widget.uID,
            classService: widget.classService,
            onUpdate: updateClassTile,
          ),
        );
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
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

                  await widget.classService.reorderClasses(reorderedList);
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
    );
  }
}
