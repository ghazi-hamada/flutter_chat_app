import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  void togglePasswordVisibility() {
    emit(LoginLoading());
    isPasswordHidden = !isPasswordHidden;
    emit(LoginInitial()); // Emit a state to rebuild the UI
  }

  void login() async {
    if (!formKey.currentState!.validate()) return;
    emit(LoginLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
