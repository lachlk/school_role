import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_role/firebase_options.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'package:school_role/pages/auth_gate.dart';
import 'package:school_role/theme.dart'; // Imports the required packages and files

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp()); // Start of the application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicTheme(
      // DynamicTheme is the theme provider
      home: Header(), // Setting Header as home widget
      body: AuthGate(), // Setting StudentList as body
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key}); // Header widget for app header

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // Shadow elevation
        shadowColor: Colors.black, // Shadow color
        toolbarHeight: 80, // Height of the app bar
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))), // Custom shape for appbar
        leading: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
          color: Theme.of(context)
              .colorScheme
              .outline, // Icon color based on dark or light mode
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: SignOutButton()
          ),
        ],
      ),
      body: const AuthGate(),
    );
  }
}

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
      child: Text(
        "sign out",
      style: TextStyle(
        color: Theme.of(context).colorScheme.outline), // Text color based on dark or light mode
      ),
      onPressed: () => FirebaseUIAuth.signOut(
        context: context,
        auth: auth,
      ),
    );
  }
}