import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'cascading_menu.dart';
import 'package:school_role/main.dart';

class ClassGridTile extends StatelessWidget {
  const ClassGridTile({
    super.key,
    required this.className,
    required this.classID,
    required this.uID,
    required this.onRefresh,
    required this.classService,
    required this.onDelete,
    required this.onUpdate,
  });

  final String className;
  final String classID;
  final String uID;
  final ClassService classService;
  final VoidCallback onRefresh;
  final VoidCallback? onDelete;
  final void Function(String classId, String newName) onUpdate;

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
                ThirdRoute(classID: classID),
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
                classID: classID,
                classService: classService,
                onDelete: onDelete ?? () {},
                onRefresh: onRefresh,
                onUpdate: onUpdate,
              ),
            ),
            footer: GridTileBar(
              title: Text(
                className,
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