import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_page_widgets/class_grid_tile.dart';
import 'package:school_role/widgets/modular_draggable_grid_view.dart';

typedef DragCompletionCallback = Future<void> Function(
  List<DraggableGridItem> reorderedList,
  int beforeIndex,
  int afterIndex,
);

class ClassesList extends StatefulWidget {
  const ClassesList({
    super.key,
    required this.uID,
    required this.classService,
  });

  final String uID;
  final ClassService classService;

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  final List<DraggableGridItem> draggableItems = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.classService.streamClassList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading classes: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No classes found'));
        }

        final classes = snapshot.data!;
        final draggableItems = <DraggableGridItem>[]
          ..clear()
          ..addAll(classes.map((c) {
            final classID = c['id'] as String;
            final className = c['name'] as String;
            return DraggableGridItem(
              isDraggable: true,
              child: ClassGridTile(
                classID: classID,
                className: className,
                uID: widget.uID,
                classService: widget.classService,
              ),
            );
          }));

        return SafeArea(
          child: Scrollbar(
            controller: scrollController,
            thickness: 10,
            radius: const Radius.circular(5),
            child: ModularDraggableGridView(
              scrollController: scrollController,
              draggableItems: draggableItems,
              onDragComplete: (reordered, beforeIndex, afterIndex) async {
                await widget.classService.reorderClasses(
                  reordered.map((e) => (e.child as ClassGridTile).classID).toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}