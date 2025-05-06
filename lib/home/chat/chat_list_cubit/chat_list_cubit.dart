import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  sendInvitation() {
    if (!formKey.currentState!.validate()) return;
    emit(ChatListLoading());
    FireDatabase().createRoom(email: emailController.text);
    emailController.clear();
    emit(ChatListCreated());
  }
  void getRooms() async{
    
  }
}
