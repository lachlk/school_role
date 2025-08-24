import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/widgets/class_page_widgets/classes_list.dart';

class ModularDraggableGridView extends StatelessWidget {
  const ModularDraggableGridView({
    super.key,
    required this.scrollController,
    required this.draggableItems,
    required this.onDragComplete,
    this.dragFeedbackBuilder,
    this.dragPlaceHolderBuilder,
  });

  final ScrollController scrollController;
  final List<DraggableGridItem> draggableItems;
  final DragCompletionCallback onDragComplete;
  final Widget Function(List<DraggableGridItem> list, int index)? dragFeedbackBuilder;
  final DragPlaceHolder? dragPlaceHolderBuilder;

  @override
  Widget build(BuildContext context) {
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
      dragPlaceHolder: dragPlaceHolderBuilder ??
          (list, index) => PlaceHolderWidget(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
