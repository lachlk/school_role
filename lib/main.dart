import 'package:flutter/material.dart';

void main() async {
  runApp( const MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          toolbarHeight: 80,
          leading: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
              },
              color: Colors.black,
            ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text(
                  'sign out',
                  style: TextStyle(color: Colors.black),
                ),
             ),
            ),
          ],
        ),
      ),
    );
  }
}
