import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'cascading_menu.dart';
import 'package:school_role/main.dart';

/// A stateless widget that represents a single, interactive grid tile for a class.
///
/// This widget displays a class name and provides functionality to navigate to
/// the student page for that class or access a cascading menu for class options.
class ClassGridTile extends StatelessWidget {
  const ClassGridTile({
    super.key,
    required this.classID,
    required this.className,
    required this.uID,
    required this.classService,
  });

  /// The unique identifier of the class.
  final String classID;
  /// The name of the class.
  final String className;
  /// The unique identifier of the user (teacher).
  final String uID;
  /// An instance of `ClassService` to manage class data.
  final ClassService classService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThirdRoute(
                classID: classID,
                className: className,
              ),
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
                child: Icon(
                  Icons.groups,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
