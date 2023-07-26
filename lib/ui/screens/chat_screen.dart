import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/data/db/entity/chat.dart';
import 'package:filmapp/data/db/entity/message.dart';
import 'package:filmapp/data/db/remote/firebase_database_source.dart';
import 'package:filmapp/ui/widgets/chats_list.dart';
import 'package:filmapp/ui/widgets/message_bubble.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final messageTextController = TextEditingController();

  static const String id = 'chat_screen';

  final String chatId;
  final String myUserId;
  final String otherUserId;

  ChatScreen({
    super.key,
    required this.chatId,
    required this.myUserId,
    required this.otherUserId,
  });

  void checkAndUpdateLastMessageSeen(
      Message lastMessage, String messageId, String myUserId) {
    if (lastMessage.seen == false && lastMessage.senderId != myUserId) {
      lastMessage.seen = true;
      Chat updatedChat = Chat(chatId, lastMessage);

      _databaseSource.updateChat(updatedChat);
      _databaseSource.updateMessage(chatId, messageId, lastMessage);
    }
  }

  bool shouldShowTime(Message currentMessage, Message messageBefore) {
    int miliHalfHour = 1800000;

    if ((messageBefore.epochTimeMs - currentMessage.epochTimeMs).abs() >
        miliHalfHour) {
      return true;
    }
    return messageBefore == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: _databaseSource.observeUser(otherUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) return Container();
            return ChatTopBar(user: AppUser.fromSnapshot(snapshot.data!));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseSource.observeMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                List<Message> messages = [];
                for (var element in snapshot.data!.docs) {
                  messages.add(Message.fromSnapshot(element));
                }
                if (snapshot.data!.docs.isNotEmpty) {
                  checkAndUpdateLastMessageSeen(
                      messages.first, snapshot.data!.docs[0].id, myUserId);
                }
                if (_scrollController.hasClients) _scrollController.jumpTo(0.0);

                List<bool> showTimeList =
                    List<bool>.generate(messages.length, (index) => false);

                for (int i = messages.length - 1; i >= 0; i--) {
                  bool shouldShow = i == (messages.length - 1)
                      ? true
                      : shouldShowTime(messages[i], messages[i + 1]);
                  showTimeList[i] = shouldShow;
                }
                return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final item = messages[index];
                    return ListTile(
                      title: MessageBubble(
                          epochTimeMs: item.epochTimeMs,
                          text: item.text,
                          isSenderMyUser: messages[index].senderId == myUserId,
                          includeTime: showTimeList[index]),
                    );
                  },
                );
              },
            ),
          ),
          getBottomContainer(context, myUserId)
        ],
      ),
    );
  }

  void sendMessage(String myUserId) {
    if (messageTextController.text.isEmpty) return;

    Message message = Message(DateTime.now().millisecondsSinceEpoch, false,
        myUserId, messageTextController.text);
    Chat updatedChat = Chat(chatId, message);
    _databaseSource.addMessage(chatId, message);
    _databaseSource.updateChat(updatedChat);
    messageTextController.clear();
  }

  Widget getBottomContainer(BuildContext context, String myUserId) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: kSecondaryColor.withOpacity(.5),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                controller: messageTextController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  color: kSecondaryColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Message',
                  labelStyle: TextStyle(
                    color: kSecondaryColor.withOpacity(.5),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: () {
                sendMessage(myUserId);
              },
              child: Text(
                'SEND',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
