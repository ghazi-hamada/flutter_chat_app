part of 'edit_group_cubit.dart';

abstract class EditGroupState extends Equatable {
  const EditGroupState();

  @override
  List<Object> get props => [];
}

class EditGroupInitial extends EditGroupState {}

class EditGroupLoading extends EditGroupState {}

class EditGroupSuccess extends EditGroupState {}
