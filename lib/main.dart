import 'package:flutter/material.dart';
import 'package:school_role/pages/presence_page.dart';
import 'package:school_role/theme.dart'; // Imports the required packages and files

void main() async {
  runApp(const MyApp()); // Start of the application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicTheme(
      // DynamicTheme is the theme provider
      home: Header(), // Setting Header as home widget
      body: StudentList(), // Setting StudentList as body
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
              .onPrimary, // Icon color based on dark or light mode
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Sign Out',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary), // Text color based on dark or light mode
              ),
            ),
          ),
        ],
      ),
      body: const StudentList(),
    );
  }
}
