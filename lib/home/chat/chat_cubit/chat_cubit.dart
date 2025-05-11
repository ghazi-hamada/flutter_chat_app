import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  TextEditingController messageController = TextEditingController();
  List<String> messagesIdSelected = [];
  List<String> messagesTextSelected = [];
  void selectMessage(String id) {
    emit(ChatLoading());
    if (messagesIdSelected.contains(id)) {
      messagesIdSelected.remove(id);
    } else {
      messagesIdSelected.add(id);
    }
    emit(ChatInitial());
  }

  void selectMessageText(String text) {
    emit(ChatLoading());
    if (messagesTextSelected.contains(text)) {
      messagesTextSelected.remove(text);
    } else {
      messagesTextSelected.add(text);
    }
    emit(ChatInitial());
  }

  void deleteMessage(String roomId) {
    emit(ChatLoading());
    FireDatabase().deleteMessage(roomId, messagesIdSelected);
    messagesIdSelected = [];
    emit(ChatInitial());
  }

  void sendMessage(ChatUser user, String roomId, [String? message]) {
    if (messageController.text.isEmpty && message == null) return;
    FireDatabase().sendMessage(
      user.id.toString(),
      message ?? messageController.text,
      roomId.toString(),
    );
    messageController.clear();
  }
  void clean() {
    emit(ChatLoading());
    messagesIdSelected = [];
    messagesTextSelected = [];
    emit(ChatInitial());
  }
}
