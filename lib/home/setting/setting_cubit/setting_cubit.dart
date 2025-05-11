import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/core/uploadfiles.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  File? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  void setControllers({
    required String name,
    required String about,
  }) {
    nameController.text = name;
    aboutController.text = about;
  }
  bool isEditingName = false;
  bool isEditingAbout = false;

  void toggleEditName() { emit(SettingLoading());
    isEditingName = !isEditingName;
    emit(SettingInitial());
  }

  void toggleEditAbout() { emit(SettingLoading());
    isEditingAbout = !isEditingAbout;
    emit(SettingInitial());
  }

  Future<void> chooseImage({required bool isGallery}) async {
    emit(SettingLoading());
    try {
      image = isGallery ? await fileUploadGallery() : await imageUploadCamera();
      log(image!.path);
    } catch (e) {
      print(e);
    }
    emit(SettingInitial());
  }

  void updateProfile() async {
    emit(SettingLoading());
    await FireDatabase().updataMyProfile(
      name: nameController.text,
      about: aboutController.text,
      file: image,
    );

    emit(SettingSuccess());
  }
}
