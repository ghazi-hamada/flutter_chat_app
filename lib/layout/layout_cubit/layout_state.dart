part of 'layout_cubit.dart';

abstract class LayoutState extends Equatable {
  const LayoutState();

  @override
  List<Object> get props => [];
}

class LayoutInitial extends LayoutState {}

class LayoutLoading extends LayoutState {}

class LayoutError extends LayoutState {
  final String message;
  
  const LayoutError(this.message);
  
  @override
  List<Object> get props => [message];
}
