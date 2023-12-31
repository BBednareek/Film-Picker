import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/chat_screen.dart';
import 'package:filmapp/ui/screens/login_screen.dart';
import 'package:filmapp/ui/screens/matched_screen.dart';
import 'package:filmapp/ui/screens/register_screen.dart';
import 'package:filmapp/ui/screens/splash_screen.dart';
import 'package:filmapp/ui/screens/start_screen.dart';
import 'package:filmapp/ui/screens/top_navigation_screen.dart';
import 'package:filmapp/util/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FilmApp());
}

class FilmApp extends StatelessWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: kFontFamily,
          colorScheme: ColorScheme.fromSwatch(),
          indicatorColor: kAccentColor,
          primarySwatch:
              const MaterialColor(kBackgroundColorInt, kThemeMaterialColor),
          scaffoldBackgroundColor: kPrimaryColor,
          hintColor: kSecondaryColor,
          buttonTheme: const ButtonThemeData(
            splashColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 14),
            buttonColor: kAccentColor,
            textTheme: ButtonTextTheme.accent,
            highlightColor: Color.fromRGBO(0, 0, 0, .3),
            focusColor: Color.fromRGBO(0, 0, 0, .3),
          ),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          StartScreen.id: (context) => const StartScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          TopNavigationScreen.id: (context) => TopNavigationScreen(),
          MatchedScreen.id: (context) => MatchedScreen(
                myProfilePhotoPath: (ModalRoute.of(context)?.settings.arguments
                    as Map)['my_profile_photo_path'],
                myUserId: (ModalRoute.of(context)?.settings.arguments
                    as Map)['my_user_id'],
                otherUserProfilePhotoPath: (ModalRoute.of(context)
                    ?.settings
                    .arguments as Map)['other_user_profile_photo_path'],
                otherUserId: (ModalRoute.of(context)?.settings.arguments
                    as Map)['other_user_id'],
              ),
          ChatScreen.id: (context) => ChatScreen(
              chatId: (ModalRoute.of(context)?.settings.arguments
                  as Map)['chat_id'],
              otherUserId: (ModalRoute.of(context)?.settings.arguments
                  as Map)['other_user_id'],
              myUserId: (ModalRoute.of(context)?.settings.arguments
                  as Map)['user_id'])
        },
      ),
    );
  }
}
