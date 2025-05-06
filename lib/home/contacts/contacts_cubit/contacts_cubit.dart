import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  void changeSearch() {
    emit(ContactsLoading());
    isSearch = !isSearch;
    emit(ContactsInitial());
  }
}
