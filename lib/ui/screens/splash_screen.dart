// ignore_for_file: use_build_context_synchronously

import 'package:filmapp/ui/screens/start_screen.dart';
import 'package:filmapp/ui/screens/top_navigation_screen.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:filmapp/util/shared_preferences_utils.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkIfUserExists();
    super.initState();
  }

  Future<void> checkIfUserExists() async {
    String? userId = await SharedPreferencesUtil.getUserId();
    Navigator.pop(context);
    // ignore: unnecessary_null_comparison
    if (userId != null) {
      Navigator.pushNamed(context, TopNavigationScreen.id);
    } else {
      Navigator.pushNamed(context, StartScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(padding: kDefaultPadding, child: Container()),
      ),
    );
  }
}
