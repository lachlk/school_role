import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_page_widgets/class_grid_tile.dart';
import 'package:school_role/widgets/modular_draggable_grid_view.dart';

// Defines a type alias for the drag completion callback function.
typedef DragCompletionCallback = Future<void> Function(
  List<DraggableGridItem> reorderedList,
  int beforeIndex,
  int afterIndex,
);

/// A `StatefulWidget` that displays a draggable list of classes.
///
/// It fetches class data from a stream and presents it in a draggable grid.
/// It also handles the reordering of classes.
class ClassesList extends StatefulWidget {
  const ClassesList({
    super.key,
    required this.uID,
    required this.classService,
  });

  /// The unique identifier of the user (teacher).
  final String uID;
  /// An instance of `ClassService` to interact with class data.
  final ClassService classService;

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  // A list to hold the draggable items.
  final List<DraggableGridItem> draggableItems = [];
  // A scroll controller for the draggable grid
  late final ScrollController scrollController;

  /// Initializes the state.
  ///
  /// This method is called once when the widget is inserted into the widget tree.
  /// It initializes the `ScrollController`.
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // Uses a `StreamBuilder` to listen for real time updates to the list of classes.
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

        // Retrieves the list of classes from the snapshot.
        final classes = snapshot.data!;
        // Creates a list of `DraggableGridItem` widgets from the class data.
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