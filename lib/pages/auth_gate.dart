import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:school_role/main.dart';// Imports required packages

class AuthGate extends StatelessWidget {
  const AuthGate({super.key}); // AuthGate widget for pages body

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(), // Email provider
              GoogleProvider(clientId: '383663275074-gpd9vodt5dt17tpakqrfg2o96jo9dtog.apps.googleusercontent.com'), // Google provider
            ],
            headerBuilder: (context, constraints, shrinkOFFset) {  // Builds the contents of the header. 
              return const Padding(
                padding: EdgeInsets.all(20),
              );
            },
            subtitleBuilder: (context, action) { // Builds the text for above the auth related widgets
             return Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0),
               child: action == AuthAction.signIn
                   ? const Text('Welcome to School Role, please sign in!')
                   : const Text('Welcome to School Role, please sign up!'),
             );
           },
           footerBuilder: (context, action) { // Builds the text for below the auth related widgets
             return const Padding(
               padding: EdgeInsets.only(top: 16),
               child: Text(
                 'By signing in, you agree to our terms and conditions.',
                 style: TextStyle(color: Colors.grey),
               ),
             );
           },
           sideBuilder: (context, shrinkOffset) { // Builds the contents that goes to the left of the auth
             return const Padding(
               padding: EdgeInsets.all(20),
               child: AspectRatio(
                 aspectRatio: 1,
                 child: FittedBox(child: Icon(Icons.local_library)), // Temporary img from tutorial
               ),
             );
           },
          );
        }

        String uID = FirebaseAuth.instance.currentUser!.uid;

        return SecondRoute(uID: uID); // Returns SecondRoute after authentication
      },
    );
  }
}
