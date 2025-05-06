import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';

class FireDatabase {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  createRoom({required String email}) async {
    QuerySnapshot snapshot =
        await fireStore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

    if (snapshot.docs.isNotEmpty) {
      String userId = snapshot.docs.first.id;

      List<String> members = [myUid, userId]..sort((a, b) => a.compareTo(b));
      QuerySnapshot roomExist =
          await fireStore
              .collection('rooms')
              .where('members', isEqualTo: members)
              .get();
      if (roomExist.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
          id: members.toString(),
          members: members,
          lastMessage: '',
          lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
          createAt: DateTime.now().millisecondsSinceEpoch.toString(),
        );
        fireStore
            .collection('rooms')
            .doc(members.toString())
            .set(chatRoom.toJson());
      }
    }
  }

  sendMessage(String uid, String message, String roomId,[String? type]) async {
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    MessageModel messageModel = MessageModel(
      id: messageId,
      senderId: myUid,
      reciverId: uid,
      message: message,
      type: type ?? 'text',
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      read: '',
    );
    await fireStore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .set(messageModel.toMap());
  }
}
