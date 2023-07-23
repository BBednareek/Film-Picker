import 'package:filmapp/data/model/chat_with_user.dart';
import 'package:filmapp/util/constants.dart';
import 'package:filmapp/util/utils.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final ChatWithUser chatWithUser;
  final VoidCallback onTap;
  final Function onLongPress;
  final String myUserId;

  const ChatListTile(
      {super.key,
      required this.chatWithUser,
      required this.onTap,
      required this.onLongPress,
      required this.myUserId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {},
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccentColor, width: 1),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(chatWithUser.user.profilePhotoPath),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [getTopRow(), getBottomRow()],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isLastMessageMyText() {
    return chatWithUser.chat.lastMessage?.senderId == myUserId;
  }

  bool isLastMessageSeen() {
    if (chatWithUser.chat.lastMessage?.seen == false &&
        isLastMessageMyText() == false) {
      return false;
    }
    return true;
  }

  Widget getTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            chatWithUser.user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
            chatWithUser.chat.lastMessage == null
                ? ''
                : epochToDateTime(chatWithUser.chat.lastMessage!.epochTimeMs),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget getBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Opacity(
            opacity: 0.6,
            child: Text(
              chatWithUser.chat.lastMessage == null
                  ? "Write something!"
                  : ((isLastMessageMyText() ? "You: " : "") +
                      chatWithUser.chat.lastMessage!.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        SizedBox(
            width: 40,
            child: chatWithUser.chat.lastMessage == null ||
                    isLastMessageSeen() == false
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: kAccentColor, shape: BoxShape.circle),
                  )
                : null)
      ],
    );
  }
}
