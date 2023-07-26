import 'package:filmapp/data/db/remote/response.dart';
import 'package:filmapp/data/model/user_registration.dart';
import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/start_screen.dart';
import 'package:filmapp/ui/screens/top_navigation_screen.dart';
import 'package:filmapp/ui/widgets/custom_modal_progress_hud.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:filmapp/util/utils.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final int _endScreenIndex = 3;
  int _currentScreenIndex = 0;
  bool _isLoading = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  void registerUser() async {
    setState(() {
      _isLoading = true;
    });

    await _userProvider
        .registerUser(_userRegistration, _scaffoldKey)
        .then((res) {
      if (res is Success) {
        Navigator.pop(context);
        Navigator.pushNamed(context, TopNavigationScreen.id);
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  void goBackPressed() {
    if (_currentScreenIndex == 0) {
      Navigator.pop(context);
      Navigator.pushNamed(context, StartScreen.id);
    } else {
      _currentScreenIndex--;
    }
  }

  Widget getSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return NameScreen(
            onChanged: (value) => {_userRegistration.name = value});
      case 1:
        return AddPhotoScreen(
            onPhotoChanged: (value) =>
                {_userRegistration.localProfilePhotoPath = value});
      case 2:
        return EmailAndPasswordScreen(
            emailOnChanged: (value) => {_userRegistration.email = value},
            passwordOnChanged: (value) => {_userRegistration.password = value});
      default:
        return Container();
    }
  }

  bool canContinueToTheNextSubScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return (_userRegistration.name.length >= 2);
      case 1:
        return (_userRegistration.localProfilePhotoPath.isNotEmpty);
      default:
        return false;
    }
  }

  String getInvalidRegistrationMessage() {
    switch (_currentScreenIndex) {
      case 0:
        return 'Name is too short';
      case 1:
        return 'Invalid photo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('Register')),
        body: CustomModalProgressHUD(
          inAsyncCall: _isLoading,
          offset: Offset.zero,
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                LinearPercentIndicator(
                  lineHeight: 5,
                  percent: (_currentScreenIndex / _endScreenIndex),
                  progressColor: kAccentColor,
                  padding: EdgeInsets.zero,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: kDefaultPadding.copyWith(
                      left: kDefaultPadding.left / 2,
                      right: 0,
                      bottom: 4,
                      top: 4,
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        _currentScreenIndex == 0
                            ? Icons.clear
                            : Icons.arrow_back,
                        color: kSecondaryColor,
                        size: 42,
                      ),
                      onPressed: () => goBackPressed(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
                    child: getSubScreen(),
                  ),
                ),
                Container(
                  padding: kDefaultPadding,
                  child: _currentScreenIndex == (_endScreenIndex)
                      ? ElevatedButtonWidget(
                          text: 'REGISTER',
                          onPressed: _isLoading == false
                              ? () => {registerUser()}
                              : null)
                      : ElevatedButtonWidget(
                          text: 'CONTINUE',
                          onPressed: () => {
                                if (canContinueToTheNextSubScreen())
                                  {
                                    setState(() {
                                      _currentScreenIndex++;
                                    })
                                  }
                                else
                                  {
                                    showSnackBar(_scaffoldKey,
                                        getInvalidRegistrationMessage())
                                  }
                              }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
