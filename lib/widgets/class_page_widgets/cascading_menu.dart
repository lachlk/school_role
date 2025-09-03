import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'class_bottom_sheet.dart';

/// A stateless widget that provides a cascading menu with 'Delete' and 'Edit'
/// options for a specific class.
class CascadingMenu extends StatelessWidget {
  const CascadingMenu({
    super.key,
    required this.classID,
    required this.classService,
  });

  /// The unique identifier of the class.
  final String classID;
  /// An instance of `ClassService` to perform database operations like
  /// deleting or fetching class data.
  final ClassService classService;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete),
          child: const Text('Delete'),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Class'),
              content: const Text('Are you sure you want to delete this class?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await classService.deleteClass(classID);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.edit),
          child: const Text('Edit'),
          onPressed: () async {
            final data = await classService.getClassById(classID);
            if (data == null) return;

            final controller = TextEditingController(text: data['name'] ?? '');
            final initialDays = Map<String, int?>.from(data['schedule'] ?? {});

            if (!context.mounted) return;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => ClassBottomSheet(
                controller: controller,
                classService: classService,
                initialSelection: initialDays,
                classId: classID,
              ),
            );
          },
        ),
      ],
      builder: (context, controller, child) => IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
