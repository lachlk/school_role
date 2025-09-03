// Imports necessary packages for Flutter and Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_role/firebase_options.dart';

// Imports custom application pages and theme.
import 'package:school_role/pages/auth_gate.dart';
import 'package:school_role/pages/classes_page.dart';
import 'package:school_role/pages/student_page.dart';
import 'package:school_role/theme.dart';

// The entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const DynamicTheme(),
  );
}

/// A stateless widget that serves as the first route of the application, auth page.
class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate();
  }
}

/// A stateless widget representing the second route, classes page.
class SecondRoute extends StatelessWidget {
  const SecondRoute({
    super.key,
    required this.uID,
  });

  final String uID;

  @override
  Widget build(BuildContext context) {
    return ClassesPage(uID: uID);
  }
}

/// A stateless widget representing the third route, student page.
class ThirdRoute extends StatelessWidget {
  const ThirdRoute({
    super.key,
    required this.classID,
    required this.className,
  });

  final String classID;
  final String className;

  @override
  Widget build(BuildContext context) {
    final String schoolID = FirebaseAuth.instance.currentUser!.uid;

    return StudentPage(
      classID: classID,
      schoolID: schoolID,
      className: className,
    );
  }
}