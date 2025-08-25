import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_role/firebase_options.dart';

import 'package:school_role/pages/auth_gate.dart';
import 'package:school_role/pages/classes_page.dart';
import 'package:school_role/pages/student_page.dart';
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
    return AuthGate(); // Setting AuthGate as body
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({
    super.key,
    required this.uID,
  }); // Second route for page navigation

  final String uID;

  @override
  Widget build(BuildContext context) {
    return ClassesPage(uID: uID);
  }
}

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({
    super.key,
    required this.classID
  }); // Third route for page navigation

  final String classID;

  @override
  Widget build(BuildContext context) {
    return StudentPage(classID: classID);
  }
}
