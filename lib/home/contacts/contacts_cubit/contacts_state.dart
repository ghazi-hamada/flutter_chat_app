part of 'contacts_cubit.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<User> contacts;
  const ContactsLoaded(this.contacts);
}

class ContactsFailure extends ContactsState {
  final String message;
  const ContactsFailure(this.message);
}
