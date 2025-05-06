part of 'setting_cubit.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingChange extends SettingState {}

class SettingFailure extends SettingState {}

class SettingSuccess extends SettingState {}

class SettingLoading extends SettingState {}
