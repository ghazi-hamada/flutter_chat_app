import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(CreateGroupInitial());
  List<String> membersId = [];
  TextEditingController nameGroupController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void addMember(String id) {
    emit(CreateGroupLoading());
    if (!membersId.contains(id)) {
      membersId.add(id);
    } else {
      membersId.remove(id);
    }
    emit(CreateGroupInitial());
  }

  void clean() {
    emit(CreateGroupLoading());
    membersId = [];
    emit(CreateGroupInitial());
  }

  void createGroup() {
    if (!formKey.currentState!.validate()) return;
    emit(CreateGroupLoading());
    if (!membersId.contains(FirebaseAuth.instance.currentUser!.uid)) {
      membersId.add(FirebaseAuth.instance.currentUser!.uid);
    }

    FireDatabase().createGroup(
      name: nameGroupController.text,
      members: membersId,
    );
    clean();
    nameGroupController.clear();
    emit(CreateGroupCreated());
  }
}
