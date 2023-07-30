// ignore_for_file: use_build_context_synchronously

import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/chat_screen.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';
import 'package:filmapp/ui/widgets/portrait.dart';
import 'package:filmapp/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchedScreen extends StatelessWidget {
  static const String id = 'matched_screen';

  final String myProfilePhotoPath;
  final String myUserId;
  final String otherUserProfilePhotoPath;
  final String otherUserId;

  const MatchedScreen({
    super.key,
    required this.myProfilePhotoPath,
    required this.myUserId,
    required this.otherUserProfilePhotoPath,
    required this.otherUserId,
  });

  void sendMessagePressed(BuildContext context) async {
    AppUser user = await Provider.of<UserProvider>(context, listen: false).user;

    Navigator.pop(context);
    Navigator.pushNamed(context, ChatScreen.id, arguments: {
      'chat_id': compareCombineIds(myUserId, otherUserId),
      'user_id': user.id,
      'other_user_id': otherUserId
    });
  }

  void keepSwipingPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 42,
            horizontal: 18,
          ),
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('images/tinder_icon.png', width: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Portrait(imageUrl: myProfilePhotoPath),
                  Portrait(imageUrl: otherUserProfilePhotoPath)
                ],
              ),
              Column(
                children: [
                  ElevatedButtonWidget(
                    text: 'SEND MESSAGE',
                    onPressed: () {
                      keepSwipingPressed(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
