import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String name = 'Film Picker';
  String textOne = 'Zapomniałeś hasła?';
  String textTwo = 'Podaj swój adres e-mail i je zresetuj!';

  final _emailController = TextEditingController();
  static final auth = FirebaseAuth.instance;

  Future resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

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
            ],
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.black,
        child: InkWell(
          onTap: () async {
            try {
              resetPassword(email: _emailController.text.trim());
              Navigator.pop(context);
            } on FirebaseAuthException catch (e) {
              showDialog(
                context: context,
                builder: (context) => dialog(e.code),
              );
            }
            resetPassword(email: _emailController.text.trim());
          },
          child: SizedBox(
            height: kToolbarHeight + screenHeight * .03,
            width: screenWidth,
            child: const Center(
              child: Text(
                'Wyślij link resetujący',
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
