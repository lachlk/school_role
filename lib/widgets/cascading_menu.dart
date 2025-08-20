import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';

class CascadingMenu extends StatelessWidget {
  const CascadingMenu({
    super.key,
    required this.classID,
    required this.onDelete,
    required this.classService
  });

  final String classID;
  final ClassService classService;
  final VoidCallback onDelete;

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