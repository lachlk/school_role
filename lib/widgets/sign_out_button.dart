import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_role/main.dart';

class SignOutButton extends StatelessWidget {
  /// {@macro ui.auth.auth_controller.auth}
  final fba.FirebaseAuth? auth;

  /// {@macro ui.shared.widgets.button_variant}
  final ButtonVariant variant;

  /// {@macro ui.auth.widgets.sign_out_button}
  const SignOutButton({
    super.key,
    this.auth,
    this.variant = ButtonVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        "Sign Out",
        style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onPrimary), // Text color based on dark or light mode
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Do you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  // When pressed runs FirstRoute
                  context,
                  MaterialPageRoute<FirstRoute>(
                    builder: (context) => const FirstRoute(),
                  ),
                );
                FirebaseUIAuth.signOut(
                  // Firebase auth signs user out
                  context: context,
                  auth: auth,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
