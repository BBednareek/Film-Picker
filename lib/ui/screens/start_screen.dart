import 'package:filmapp/ui/screens/login_screen.dart';
import 'package:filmapp/ui/widgets/app_image_with_text.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';
import 'package:filmapp/ui/widgets/rounded_outlined_button.dart';
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Lorel ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Nulla in orci justo. Curabitur ac gravida quam.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButtonWidget(
                    text: 'CREATE ACCOUNT',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RegisterScreen.id);
                    }),
                const SizedBox(height: 20),
                RoundedOutlinedButton(
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
