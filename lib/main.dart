import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_role/firebase_options.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'package:school_role/pages/auth_gate.dart';
import 'package:school_role/pages/classes_page.dart';
import 'package:school_role/pages/presence_page.dart';
import 'package:school_role/theme.dart'; // Imports the required packages and files

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const DynamicTheme(),
  ); // Start of the application
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key}); // First route for page navigation

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        onBackTap: null,
      ), // Setting MyAppBar as appBar widget
      body: AuthGate(), // Setting AuthGate as body
    );
  }
}

class SecondRoute extends StatelessWidget {
  final String uID;

  const SecondRoute({super.key, required this.uID}); // Second route for page navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClassesList(uID: uID), // Setting ClassesList as body
    );
  }
}

class ThirdRoute extends StatelessWidget {
  final String classID;

  const ThirdRoute({super.key, required this.classID}); // Third route for page navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onBackTap: () {
        Navigator.pop(
          context,
          MaterialPageRoute<FirstRoute>(
            builder: (context) => ThirdRoute(classID: classID,),
          ),
        );
      }), // Setting MyAppBar as appBar widget
      body: StudentList(classID: classID), // Setting StudentList as body
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic onBackTap;

  const MyAppBar(
      {super.key, required this.onBackTap}); // MyAppBar widget for app header

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2, // Shadow elevation
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
        color: Theme.of(context)
            .colorScheme
            .outline, // Icon color based on dark or light mode
      ),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 10.0), child: SignOutButton()),
      ],
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
            color: Theme.of(context)
                .colorScheme
                .outline), // Text color based on dark or light mode
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
