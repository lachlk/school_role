import 'class_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';

class CascadingMenu extends StatelessWidget {
  const CascadingMenu({
    super.key,
    required this.classID,
    required this.classService,
    required this.onDelete,
    required this.onRefresh, 
    required this.onUpdate,
  });

  final String classID;
  final ClassService classService;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;
  final void Function(String classId, String newName) onUpdate;

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
                    await classService.deleteClass(classID);
                    onDelete();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
          child: Text('Delete'),
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.edit),
          onPressed: () async {
            final data = await classService.getClassById(classID);
            if (data == null) return;

            final controller = TextEditingController(text: data['name'] ?? '');
            final initialDays = Map<String, int?>.from(data['schedule'] ?? {});
            final uID = (data['userID'] as List).isNotEmpty ? data['userID'][0] : '';

            if (!context.mounted) return;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return ClassBottomSheet(
                  controller: controller,
                  uID: uID,
                  classService: classService,
                  onGetClasses: () {
                    final newName = controller.text.trim();
                    onRefresh();
                    onUpdate(classID, newName);
                  },
                  initialSelection: initialDays,
                  classId: classID,
                );
              },
            );
          },
          child: Text('Edit'),
        ),
      ],
      builder: (context, controller, child) => IconButton(
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