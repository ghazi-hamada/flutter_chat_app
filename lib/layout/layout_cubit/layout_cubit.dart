import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fire_auth.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> with WidgetsBindingObserver {
  LayoutCubit() : super(LayoutInitial()) {
    WidgetsBinding.instance.addObserver(this);

    FireAuth().updateActivatedTime(true);
  }

  int curuntIndex = 0;
  PageController pageController = PageController();

  void changeIndex(int index) {
    emit(LayoutLoading());
    curuntIndex = index;
    emit(LayoutInitial());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FireAuth().updateActivatedTime(true);
      debugPrint('Application resumed - User is ONLINE');
    } else {
      FireAuth().updateActivatedTime(false);
      debugPrint('Application ${state.name} - User is OFFLINE');
    }
  }

  @override
  Future<void> close() async {
    await FireAuth().updateActivatedTime(false);
    debugPrint('LayoutCubit closed - User is OFFLINE');

    WidgetsBinding.instance.removeObserver(this);

    return super.close();
  }
}
