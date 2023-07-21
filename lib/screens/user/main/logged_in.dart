import 'package:filmapp/screens/user/main/checker.dart';
import 'package:filmapp/screens/user/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({super.key});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              onPressed: () {
                _signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Checker()));
              },
              child: const Text('Log out'))),
    );
  }
}
