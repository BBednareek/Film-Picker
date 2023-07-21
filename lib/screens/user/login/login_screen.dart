import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:filmapp/screens/auth_helper/auth_helper.dart';
import 'package:filmapp/screens/user/login/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = 'Film Picker';
  String textOne = 'Wieczór przy filmie?';
  String textTwo = 'Wybierz seans na zasadach matchingu!';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 30, fontFamily: 'Audiowide'),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText(textOne,
                        textStyle: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Audiowide',
                            color: Colors.black),
                        duration: const Duration(seconds: 3)),
                    RotateAnimatedText(textTwo,
                        textStyle: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Audiowide',
                            color: Colors.black),
                        duration: const Duration(seconds: 3))
                  ],
                  repeatForever: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: screenWidth * .5,
                  height: screenHeight * .06,
                ),
              ),
              const SizedBox(height: 65),
              inputEmail(
                  _emailController, 'Adres e-mail', 'Podaj adres e-mail'),
              const SizedBox(height: 16),
              inputPassword(_passwordController, 'Hasło', 'Podaj hasło'),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Zapomniałem hasła',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Audiowide'),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.black,
        child: InkWell(
          onTap: () async {
            if (_emailController.text.trim().isEmpty ||
                _passwordController.text.trim().isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      dialog('Żadne pole nie może być puste!'));
            } else if (_passwordController.text.trim().length < 6) {
              showDialog(
                  context: context,
                  builder: (context) => dialog(
                      'Podane hasło jest za krótkie, bądź podane hasła nie są takie same!'));
            } else if (_emailController.text.trim().isNotEmpty &&
                _passwordController.text.trim().isNotEmpty &&
                _passwordController.text.trim().length > 6) {
              try {
                await AuthHelper.signInWithEmail(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim());
                if (!mounted) return;
              } on FirebaseAuthException catch (e) {
                if (e.code == 'wrong-password') {
                  showDialog(
                      context: context,
                      builder: (context) => dialog('Nieprawidłowe hasło!'));
                }
                if (e.code == 'invalid-email') {
                  showDialog(
                      context: context,
                      builder: (context) => dialog('Nieprawidłowy e-mail!'));
                }
                if (e.code == 'user-not-found') {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          dialog('Nie znaleziono użytkownika w naszej bazie!'));
                }
              }
            }
          },
          child: SizedBox(
            height: kToolbarHeight + screenHeight * .03,
            width: screenWidth,
            child: const Center(
              child: Text(
                'Zaloguj się',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputEmail(
      TextEditingController controller, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Audiowide'),
          labelText: labelText,
          hintStyle: const TextStyle(fontSize: 20, fontFamily: 'Audiowide'),
          hintText: hintText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Wprowadź poprawny adres mailowy'
            : null,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget inputPassword(
      TextEditingController controller, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Audiowide'),
          labelText: labelText,
          hintStyle: const TextStyle(fontSize: 20, fontFamily: 'Audiowide'),
          hintText: hintText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value != null && value.length < 6
            ? 'Wprowadź minimum 6 znaków'
            : null,
        obscureText: true,
      ),
    );
  }

  Widget dialog(String alert) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: const Color(0xFFD77A0B),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text('Ups, mamy kłopot!'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(alert),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text('Spróbuj ponownie'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
