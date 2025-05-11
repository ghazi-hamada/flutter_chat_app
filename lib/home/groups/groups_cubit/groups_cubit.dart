import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/uploadfiles.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());
  List<String> messagesId = [];
  List<String> messagesTextSelected = [];
  List<String> messagesSenderIds = [];
  String myId = FirebaseAuth.instance.currentUser!.uid;

  bool isSelectMessageNotme = false;

  void subscribeToGroupTopic(String groupId) {
    FirebaseMessaging.instance.subscribeToTopic('group_$groupId');
  }

  void selectMessageText(String text) {
    emit(GroupsLoading());
    if (messagesTextSelected.contains(text)) {
      messagesTextSelected.remove(text);
    } else {
      messagesTextSelected.add(text);
    }
    emit(GroupsInitial());
  }

  void selectMessage({required String messageId, required String senderId}) {
    emit(GroupsLoading());

    if (messagesId.contains(messageId)) {
      messagesId.remove(messageId);
      messagesSenderIds.remove(senderId);
    } else {
      messagesId.add(messageId);
      messagesSenderIds.add(senderId);
    }

    // هنا نحدث الفلاج بناءً على كل المرسلين
    isSelectMessageNotme = messagesSenderIds.any((id) => id != myId);

    emit(GroupsInitial());
  }

  TextEditingController messageController = TextEditingController();
  File? image;
  void sendMessage(String groupId, String? nameGroup) {
    if (messageController.text.isEmpty) return;
    FireDatabase().sendMessageToGroup(
      groupId,
      messageController.text,
      nameGroup,
    );
    messageController.clear();
  }

  Future<void> chooseImage({
    required bool isGallery,
    required ChatGroupModel chatGroupModel, 
  }) async {
    try {
      image = isGallery ? await fileUploadGallery() : await imageUploadCamera();
      log(image!.path);
      FireDatabase().sendImageMessageToGroup(
        chatGroupModel.id!,
        image!,
        chatGroupModel.name!,
      );
    } catch (e) {
      print(e);
    }
  }

  void clean() {
    emit(GroupsLoading());
    messagesId = [];
    messagesTextSelected = [];
    messagesSenderIds = [];
    isSelectMessageNotme = false;
    emit(GroupsInitial());
  }

  void deleteMessage(String groupId) {
    emit(GroupsLoading());
    FireDatabase().deleteMessageFromGroup(groupId, messagesId);
    messagesId = [];
    emit(GroupsInitial());
  }
}
