import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/core/helper/notifications_helper.dart';
import 'package:flutter_chat_app/firebase/fire_storage.dart';
import 'package:flutter_chat_app/home/groups/edit_group.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:http/http.dart' as http;

class FireDatabase {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String timeNew = DateTime.now().millisecondsSinceEpoch.toString();
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
          lastMessageTime: timeNew,
          createAt: timeNew,
        );
        fireStore
            .collection('rooms')
            .doc(members.toString())
            .set(chatRoom.toJson());
      }
    }
  }

  Future addContact({required String email}) async {
    QuerySnapshot snapshot =
        await fireStore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
    if (snapshot.docs.isNotEmpty) {
      String userId = snapshot.docs.first.id;
      await fireStore.collection('users').doc(myUid).update({
        'my_contacts': FieldValue.arrayUnion([userId]),
      });
    }
  }

  sendMessage(String uid, String message, String roomId, [String? type]) async {
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    MessageModel messageModel = MessageModel(
      id: messageId,
      senderId: myUid,
      reciverId: uid,
      message: message,
      type: type ?? 'text',
      time: timeNew,
      read: '',
    );
    await fireStore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .set(messageModel.toMap());
    await fireStore
        .collection('rooms')
        .doc(roomId)
        .update({
          'last_message': type == 'image' ? 'image' : message,
          'last_message_time': timeNew,
        })
        .then((value) {
          NotificationsService.sendNotificationToTopic(
            topic: 'user_$uid',
            title: FirebaseAuth.instance.currentUser!.displayName!,
            body: message,
          );
        });
  }

  sendImageMessage(String uid, File file, String roomId, [String? type]) async {
    String? imageUrl = await FireStorage().uploadFile(file);
    sendMessage(uid, imageUrl!, roomId, 'image');
  }

  sendImageMessageToGroup(String groupId, File file,String nameGroup) async {
    String? imageUrl = await FireStorage().uploadFile(file);
    sendMessageToGroup(groupId, imageUrl!, 'image').then((value) {
      NotificationsService.sendNotificationToTopic(
        topic: 'group_$groupId',
        title: nameGroup,
        body: '${FirebaseAuth.instance.currentUser!.displayName} send Image',
      );
    });
  }

  Future readMessage(String roomId, String messageId) async => await fireStore
      .collection('rooms')
      .doc(roomId)
      .collection('messages')
      .doc(messageId)
      .update({'read': timeNew});

  Future deleteMessage(String roomId, List<String> messagesId) async {
    for (String id in messagesId) {
      await fireStore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(id)
          .delete();
    }
  }

  Future deleteMessageFromGroup(String groupId, List<String> messagesId) async {
    for (String id in messagesId) {
      await fireStore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(id)
          .delete();
    }
  }

  Future createGroup({
    required String name,
    required List<String> members,
  }) async {
    ChatGroupModel chatGroupModel = ChatGroupModel(
      id: timeNew,
      name: name,
      image: '',
      members: members,
      admins: [myUid],
      lastMessage: '',
      lastMessageTime: timeNew,
      createAt: timeNew,
    );
    await fireStore
        .collection('groups')
        .doc(timeNew)
        .set(chatGroupModel.toJson());
  }

  Future sendMessageToGroup(
    String groupId,
    String message,
    String? nameGroup, [
    String? type,
  ]) async {
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    MessageModel messageModel = MessageModel(
      id: messageId,
      senderId: myUid,
      reciverId: groupId,
      message: message,
      type: type ?? 'text',
      time: timeNew,
      read: '',
    );
    await fireStore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .set(messageModel.toMap());
    await fireStore
        .collection('groups')
        .doc(groupId)
        .update({
          'last_message': type == 'image' ? 'image' : message,
          'last_message_time': timeNew,
        })
        .then((value) {
          NotificationsService.sendNotificationToTopic(
            topic: 'group_$groupId',
            title: nameGroup!,
            body: '${FirebaseAuth.instance.currentUser!.displayName}: $message',
          );
        });
  }

  editGroup({
    required String groupId,
    required String name,
    required List<String> members,
  }) async {
    await fireStore.collection('groups').doc(groupId).update({
      'name': name,
      'members': FieldValue.arrayUnion(members), // members,
    });
  }

  Future removeMemberFromGroup({
    required String groupId,
    required String memberId,
  }) async {
    await fireStore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([memberId]), // members,
    });
  }

  Future setMemberAsAdmin({
    required String groupId,
    required String memberId,
  }) async {
    await fireStore.collection('groups').doc(groupId).update({
      'admins': FieldValue.arrayUnion([memberId]), // members,
    });
  }

  Future<void> removeAdminFromGroup({
    required String groupId,
    required String memberId,
  }) async {
    final groupRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId);
    await groupRef.update({
      'admins': FieldValue.arrayRemove([memberId]), // members,
    });
  }

  Future<void> updataMyProfile({
    required String name,
    required String about,
    File? file,
  }) async {
    String? imageUrl;

    // ✅ ارفع الصورة فقط إذا تم اختيارها
    if (file != null) {
      imageUrl = await FireStorage().uploadFile(file);
    }

    // ✅ جهز البيانات للتحديث بدون ما تحط الصورة إذا مش موجودة
    final dataToUpdate = {'name': name, 'abuot': about};

    if (imageUrl != null) {
      dataToUpdate['image'] = imageUrl;
    }

    await fireStore.collection('users').doc(myUid).update(dataToUpdate);

    // ✅ حدث بيانات الحساب أيضاً
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

    if (imageUrl != null) {
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
    }
  }

  Future setImageForGroup({required String groupId, required File file}) async {
    String? imageUrl;

    // ✅ ارفع الصورة فقط إذا تم اختيارها
    imageUrl = await FireStorage().uploadFile(file);
    await fireStore.collection('groups').doc(groupId).update({
      'image': imageUrl,
    });
  }
}
