part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupError extends SignupState {
  final String message;
  const SignupError(this.message);
}

class SignupSuccess extends SignupState {}
