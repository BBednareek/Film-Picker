import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:filmapp/screens/user/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:filmapp/screens/auth_helper/auth_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isRegistered = false;
  String name = 'Film Picker';
  String textOne = 'Wieczór przy filmie?';
  String textTwo = 'Wybierz seans na zasadach matchingu!';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  showSucessfulDialog() {
    setState(() {
      isRegistered = true;
    });
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isRegistered = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                    width: screenWidth * .5, height: screenHeight * .06),
              ),
              const SizedBox(height: 65),
              inputEmail(
                  _emailController, 'Adres e-mail', 'Podaj adres e-mail'),
              const SizedBox(height: 16),
              inputPassword(_passwordController, 'Hasło', 'Podaj hasło'),
              const SizedBox(height: 16),
              inputPassword(_passwordRepeatController, 'Podaj ponownie hasło',
                  'Podaj ponownie hasło'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Masz już konto? Zaloguj się!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Audiowide',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              overlay(isRegistered),
              successful(isRegistered)
            ],
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.black,
        child: InkWell(
          onTap: () async {
            if (_emailController.text.trim().isEmpty ||
                _passwordController.text.trim().isEmpty ||
                _passwordRepeatController.text.trim().isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      dialog('Żadne pole nie może być puste!'));
            } else if (_passwordController.text.trim() !=
                    _passwordRepeatController.text.trim() ||
                _passwordController.text.trim().length < 6) {
              showDialog(
                context: context,
                builder: (context) => dialog(
                    'Podane hasło jest za krótkie, bądź podane hasła nie są takie same!'),
              );
            } else if (_emailController.text.trim().isNotEmpty &&
                _passwordController.text.trim().isNotEmpty &&
                _passwordRepeatController.text.trim().isNotEmpty &&
                _passwordController.text.trim() ==
                    _passwordRepeatController.text.trim() &&
                _passwordController.text.trim().length > 6) {
              try {
                await AuthHelper.signupWithEmail(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
                if (!mounted) return;
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  showDialog(
                    context: context,
                    builder: (context) => dialog(
                        'Podany e-mail jest nieprawidłowo sformatowany!'),
                  );
                }
                if (e.code == 'email-already-in-use') {
                  showDialog(
                    context: context,
                    builder: (context) => dialog(
                        'Podany adres mailowy istnieje już w naszej bazie!'),
                  );
                }
                if (e.code == 'weak-password') {
                  showDialog(
                    context: context,
                    builder: (context) => dialog('Zbyt słabe hasło!'),
                  );
                }
              }
            }
          },
          child: SizedBox(
            height: kToolbarHeight + screenHeight * .03,
            width: screenWidth,
            child: const Center(
              child: Text(
                'Zarejestruj się',
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

  Widget overlay(bool isSuccessful) => isSuccessful
      ? Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(.2),
        )
      : Container();

  Widget successful(bool isSuccessful) => isSuccessful
      ? Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(200),
          ),
          child: const Text(
            'Successful registration!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Audiowide',
            ),
          ),
        )
      : Container();

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
