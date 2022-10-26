import 'package:demo_project_admin/auth/login_admin.dart';
import 'package:demo_project_admin/screens/admin.dart';
import 'package:demo_project_admin/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return WelcomeScreen();
          } else {
            return Login();
          }
        } else if (snapshot.hasError) {
          return const Text('Error Occured');
        }
        return const WelcomeScreen();
      },
    );
  }
}
