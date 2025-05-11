import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void changeSearch() {
    emit(ContactsLoading());
    isSearch = !isSearch;
    searchController.clear();
    emit(ContactsInitial());
  }

  void whenSearching() {
    emit(ContactsLoading());
    emit(ContactsInitial());
  }

  createContacts() {
    emit(ContactsLoading());
     if (!formKey.currentState!.validate()) return; // check if
    FireDatabase().addContact(email: emailController.text);
    emailController.clear();
    emit(ContactsCreated());
  }
}
