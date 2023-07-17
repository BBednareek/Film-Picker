import 'package:filmapp/screens/user/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FilmApp());
}

class FilmApp extends StatefulWidget {
  const FilmApp({super.key});

  @override
  State<FilmApp> createState() => _FilmAppState();
}

class _FilmAppState extends State<FilmApp> {
  User? user;
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Film app';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: const RegisterScreen(),
    );
  }
}
