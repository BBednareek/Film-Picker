import 'package:filmapp/screens/user/main/logged_in.dart';
import 'package:filmapp/screens/user/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Checker extends StatefulWidget {
  const Checker({super.key});

  @override
  State<Checker> createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const RegisterScreen();
        }
        return const LoggedIn();
      },
    );
  }
}
