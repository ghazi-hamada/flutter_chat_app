import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  TextEditingController messageController = TextEditingController();

  void sendMessage(ChatUser user, String roomId,[String? message]) {
    FireDatabase()
        .sendMessage(
          user.id.toString(),
         message ?? messageController.text,
          roomId.toString(),
        )
        .then((value) => messageController.clear());
  }
}
