import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmapp/data/db/entity/message.dart';

class Chat {
  late String id;
  Message? lastMessage;

  Chat(this.id, this.lastMessage);

  Chat.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot['id'];
    if (snapshot['last_message'] != null) {
      lastMessage = Message.fromMap(snapshot['last_message']);
    } else {
      lastMessage = null;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'last_message': lastMessage,
    };
  }
}
