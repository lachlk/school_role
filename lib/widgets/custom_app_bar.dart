import 'package:flutter/material.dart';
import 'package:school_role/widgets/sign_out_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String? title;
  final VoidCallback? onBackTap; // 🛠️ Added: New named parameter for the back button tap

  const CustomAppBar({
    super.key,
    this.actions,
    this.title,
    this.onBackTap, // 🛠️ Added: To the constructor
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
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
      leading: onBackTap != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackTap,
              color: onBackTap == null ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2) : null,
            )
          : null,
      title: title != null ? Text(title!) : null,
      actions: allActions,
    );
  }
}