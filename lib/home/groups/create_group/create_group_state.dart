part of 'create_group_cubit.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoading extends CreateGroupState {}
class CreateGroupCreated extends CreateGroupState {}



