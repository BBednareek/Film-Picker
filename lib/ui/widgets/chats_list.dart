import 'package:filmapp/data/model/chat_with_user.dart';
import 'package:filmapp/data/model/chats_observer.dart';
import 'package:filmapp/ui/widgets/chat_list_tile.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatefulWidget {
  final List<ChatWithUser> chatWithUserList;
  final Function(ChatWithUser) onChatWithUserTap;
  final String myUserId;

  const ChatsList({
    super.key,
    required this.chatWithUserList,
    required this.onChatWithUserTap,
    required this.myUserId,
  });

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  late ChatsObserver _chatsObserver;

  @override
  void initState() {
    _chatsObserver = ChatsObserver(widget.chatWithUserList);
    _chatsObserver.startObservers(chatUpdated);
    super.initState();
  }

  @mustCallSuper
  @override
  void dispose() {
    _chatsObserver.removeObservers();
    super.dispose();
  }

  void chatUpdated() {
    setState(() {});
  }

  bool changeMessageSeen(int index) {
    return widget.chatWithUserList[index].chat.lastMessage!.seen == false &&
        widget.chatWithUserList[index].chat.lastMessage!.senderId !=
            widget.myUserId;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.grey,
      ),
      itemCount: widget.chatWithUserList.length,
      itemBuilder: (BuildContext _, int index) => ChatListTile(
        chatWithUser: widget.chatWithUserList[index],
        onTap: () {
          if (widget.chatWithUserList[index].chat.lastMessage != null &&
              changeMessageSeen(index)) {
            widget.chatWithUserList[index].chat.lastMessage!.seen = true;
            chatUpdated();
          }
        },
        onLongPress: () {},
        myUserId: widget.myUserId,
      ),
    );
  }
}
