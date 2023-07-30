import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/data/model/chat_with_user.dart';
import 'package:filmapp/data/provider/user_provider.dart';
import 'package:filmapp/ui/screens/chat_screen.dart';
import 'package:filmapp/ui/widgets/chats_list.dart';
import 'package:filmapp/ui/widgets/custom_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  void chatWithUserPressed(ChatWithUser chatWithUser) async {
    AppUser user = await Provider.of<UserProvider>(context, listen: false).user;

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, ChatScreen.id, arguments: {
      'chat_id': chatWithUser.chat.id,
      'user_id': user.id,
      'other_user_id': chatWithUser.user.id
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall: userProvider.isLoading,
                    offset: Offset.zero,
                    child: (userSnapshot.hasData)
                        ? FutureBuilder<List<ChatWithUser>>(
                            future: userProvider
                                .getChatsWithUser(userSnapshot.data!.id),
                            builder: (context, chatWithUsersSnapshot) {
                              if (chatWithUsersSnapshot.data == null &&
                                  chatWithUsersSnapshot.connectionState !=
                                      ConnectionState.done) {
                                return CustomModalProgressHUD(
                                  inAsyncCall: true,
                                  offset: Offset.zero,
                                  child: Container(),
                                );
                              } else {
                                return chatWithUsersSnapshot.data!.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No matches',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      )
                                    : ChatsList(
                                        chatWithUserList:
                                            chatWithUsersSnapshot.data ?? [],
                                        onChatWithUserTap: chatWithUserPressed,
                                        myUserId: userSnapshot.data!.id);
                              }
                            })
                        : Container());
              });
        }),
      ),
    );
  }
}
