import 'package:flutter/material.dart';
import 'package:school_role/widgets/sign_out_button.dart';

/// A custom `AppBar` widget with a specific design and functionality.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.actions,
    this.title,
    this.onBackTap,
  });

  /// An optional list of widgets to display as actions on the right side of the app bar.
  /// `SignOutButton` is always appended to this list.
  final List<Widget>? actions;
  /// Optional title for the app bar.
  final String? title;
  /// An optional callback function to be executed when the back button is tapped.
  final VoidCallback? onBackTap;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    // Creates a new list of actions by combining the provided `actions`.
    final allActions = <Widget>[
      ...(actions ?? []),
      const Padding(padding: EdgeInsets.only(right: 10.0), child: SignOutButton())
    ];

    return AppBar(
      elevation: 3,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shadowColor: Colors.black,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      // If `onBackTap` is provided an `IconButton` with a back arrow is shown.
      leading: onBackTap != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackTap,
              color: onBackTap == null ? Theme.of(context).colorScheme.onSurface : null,
            )
          : null,
      title: title != null ? Text(title!) : null,
      // Sets the list of actions to the combined list.
      actions: allActions,
    );
  }
}