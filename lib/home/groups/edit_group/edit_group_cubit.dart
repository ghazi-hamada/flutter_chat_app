import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/uploadfiles.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';

part 'edit_group_state.dart';

class EditGroupCubit extends Cubit<EditGroupState> {
  EditGroupCubit() : super(EditGroupInitial());
  final formKey = GlobalKey<FormState>();
  final nameGroupController = TextEditingController();
  List<String> membersId = [];
  File? image;
  void setData(String name, List groupMembers) {
    nameGroupController.text = name;
    membersId = List.from(groupMembers);
  }

  void addMember(String id) {
    emit(EditGroupLoading());
    if (!membersId.contains(id)) {
      membersId.add(id);
    } else {
      membersId.remove(id);
    }
    emit(EditGroupInitial());
  }

  void editGroup(String groupId) async {
    if (!formKey.currentState!.validate()) return;
    emit(EditGroupLoading());
    await FireDatabase().editGroup(
      groupId: groupId,
      name: nameGroupController.text,
      members: membersId,
    );
    emit(EditGroupSuccess());
  }

  Future<void> chooseImage({
    required bool isGallery,
    required String groupId,
  }) async {
    emit(EditGroupLoading());
    try {
      image = isGallery ? await fileUploadGallery() : await imageUploadCamera();
      log(image!.path);
      FireDatabase().setImageForGroup(groupId: groupId, file: image!);
    } catch (e) {
      print(e);
    }
    emit(EditGroupInitial());
  }
}
