import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/start_screen.dart';
import 'package:filmapp/ui/widgets/custom_modal_progress_hud.dart';
import 'package:filmapp/ui/widgets/elevated_button.dart';
import 'package:filmapp/ui/widgets/elevated_icon_button.dart';
import 'package:filmapp/ui/widgets/input_dialog.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 18),
        margin: const EdgeInsets.only(bottom: 40),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  offset: Offset.zero,
                  child: userSnapshot.hasData
                      ? Column(
                          children: [
                            getProfileImage(userSnapshot.data, userProvider),
                            const SizedBox(height: 20),
                            Text(userSnapshot.data!.name,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 40),
                            getBio(userSnapshot.data, userProvider),
                            Expanded(child: Container()),
                            ElevatedButtonWidget(
                              text: 'LOGOUT',
                              onPressed: () {
                                logoutPressed(userProvider, context);
                              },
                            )
                          ],
                        )
                      : Container(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget getBio(AppUser? user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('bio', style: Theme.of(context).textTheme.headlineMedium),
            RoundedIconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => InputDialog(
                    labelText: 'Bio',
                    onSavePressed: (value) => userProvider.updateUserBio(value),
                  ),
                );
              },
              iconData: Icons.edit,
              buttonColor: kDefaultIconDarkColor,
              paddingReduce: 4,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          user!.bio.isNotEmpty ? user.bio : 'No bio.',
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget getProfileImage(AppUser? user, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccentColor, width: 1),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user!.profilePhotoPath),
            radius: 75,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: RoundedIconButton(
            buttonColor: kAccentColor,
            onPressed: () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserProfilePhoto(
                    pickedFile.path, _scaffoldKey);
              }
            },
            iconData: Icons.edit,
            iconSize: 18,
          ),
        )
      ],
    );
  }
}
