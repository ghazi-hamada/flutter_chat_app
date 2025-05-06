import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  int curuntIndex = 0;
  PageController pageController = PageController();
  void changeIndex(int index) {
    emit(LayoutLoading());
    curuntIndex = index;
    emit(LayoutInitial());
  }
}
