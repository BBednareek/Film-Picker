import 'package:filmapp/ui/screens/login_screen.dart';
import 'package:filmapp/ui/screens/register_screen.dart';
import 'package:filmapp/ui/widgets/app_image_with_text.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  static const String id = 'start_screen';
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kDefaultPadding,
          child: Container(
            margin: const EdgeInsets.only(bottom: 40, top: 120),
            child: Column(
              children: [
                const AppIconTitle(),
                Expanded(child: Container()),
                const SizedBox(height: 60),
                ElevatedButtonWidget(
                    text: 'CREATE ACCOUNT',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RegisterScreen.id);
                    }),
                const SizedBox(height: 20),
                ElevatedButtonWidget(
                    text: 'LOGIN',
                    onPressed: () =>
                        Navigator.pushNamed(context, LoginScreen.id))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
