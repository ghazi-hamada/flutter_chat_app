import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static final auth = FirebaseAuth.instance;

  Future<void> forgetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    if (email.isEmpty) {
      emit(ForgetPasswordFailure('يرجى إدخال البريد الإلكتروني.'));
      return;
    }

    emit(ForgetPasswordLoading());

    try {
      await auth.sendPasswordResetEmail(email: email);
      emit(ForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ForgetPasswordFailure('لا يوجد مستخدم لهذا البريد.'));
      } else if (e.code == 'invalid-email') {
        emit(ForgetPasswordFailure('البريد الإلكتروني غير صالح.'));
      } else {
        emit(ForgetPasswordFailure('حدث خطأ. حاول مرة أخرى.'));
      }
    } catch (e) {
      emit(ForgetPasswordFailure('حدث خطأ غير متوقع.'));
    }
  }
}
