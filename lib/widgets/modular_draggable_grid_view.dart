import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/widgets/class_page_widgets/classes_list.dart';

/// A custom widget that wraps the `DraggableGridViewBuilder` to provide a modular,
/// reusable draggable grid view.
class ModularDraggableGridView extends StatelessWidget {
  const ModularDraggableGridView({
    super.key,
    required this.scrollController,
    required this.draggableItems,
    required this.onDragComplete,
    this.dragFeedbackBuilder,
    this.dragPlaceHolderBuilder,
  });

  /// The scroll controller for the grid view.
  final ScrollController scrollController;
  /// The list of items to be displayed in the grid.
  final List<DraggableGridItem> draggableItems;
  /// A callback function that is triggered when a drag and drop operation is completed.
  final DragCompletionCallback onDragComplete;
  /// An optional builder function for the widget shown during the drag operation.
  final Widget Function(List<DraggableGridItem> list, int index)? dragFeedbackBuilder;
  /// An optional builder function for the placeholder widget shown in the original
  /// position while an item is being dragged.
  final DragPlaceHolder? dragPlaceHolderBuilder;

  @override
  Widget build(BuildContext context) {
    // Determine the number of columns based on the screens shortest side.
    final crossAxisCount = MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4;
    final tileSize = MediaQuery.of(context).size.width / crossAxisCount - 20;

    return DraggableGridViewBuilder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      dragCompletion: (reorderedList, int beforeIndex, int afterIndex) async {
        await onDragComplete(reorderedList, beforeIndex, afterIndex);
      },
      children: draggableItems,
      isOnlyLongPress: true,
      // Provides a default placeholder widget if `dragPlaceHolderBuilder` is null.
      dragPlaceHolder: dragPlaceHolderBuilder ??
          (list, index) => PlaceHolderWidget(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
      // Provides a default feedback widget for the dragging item if `dragFeedbackBuilder` is null.
      dragFeedback: dragFeedbackBuilder ??
          (list, index) => Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 1.1,
                  child: SizedBox(
                    width: tileSize,
                    height: tileSize,
                    child: list[index].child,
                  ),
                ),
              ),
    );
  }
}
