import 'package:flutter/material.dart';

class SucessScreen extends StatefulWidget {
  const SucessScreen({super.key});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Sucessful',
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontFamily: 'Audiowide'),
          )
        ],
      ),
    );
  }
}
