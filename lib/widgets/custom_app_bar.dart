import 'package:flutter/material.dart';
import 'package:school_role/widgets/sign_out_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic onBackTap;

  const CustomAppBar(
      {super.key, required this.onBackTap}); // MyAppBar widget for app header

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 3, // Shadow elevation
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, // App bar color based on dark or light mode
      shadowColor: Colors.black, // Shadow color
      toolbarHeight: 80, // Height of the app bar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ), // Custom shape for appbar
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackTap,
        color: Theme.of(context).colorScheme.onSurface, // Icon color based on dark or light mode
      ),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 10.0), child: SignOutButton()),
      ],
    );
  }
}