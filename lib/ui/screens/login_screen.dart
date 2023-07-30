import 'package:filmapp/data/db/remote/response.dart';
import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/top_navigation_screen.dart';
import 'package:filmapp/ui/widgets/bordered_text_field.dart';
import 'package:filmapp/ui/widgets/custom_modal_progress_hud.dart';
import 'package:filmapp/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String _inputEmail = '';
  String _inputPassword = '';
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    _userProvider = Provider.of(context, listen: false);
    super.initState();
  }

  void loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    await _userProvider
        .loginUser(_inputEmail, _inputPassword, _scaffoldKey)
        .then((res) {
      if (res is Success<UserCredential>) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(TopNavigationScreen.id, (route) => false);
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          offset: Offset.zero,
          child: Padding(
            padding: kDefaultPadding,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 40),
                  BorderedTextField(
                    labelText: 'Email',
                    onChanged: (value) => _inputEmail = value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 5),
                  BorderedTextField(
                    labelText: 'Password',
                    onChanged: (value) => _inputPassword = value,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  Expanded(child: Container()),
                  ElevatedButtonWidget(
                      text: 'LOGIN', onPressed: () => loginPressed()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
