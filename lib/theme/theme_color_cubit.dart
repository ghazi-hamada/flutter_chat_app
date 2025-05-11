import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColorCubit extends Cubit<Color> {
  ThemeColorCubit() : super(Colors.blue) {
    loadSavedColor();
  } // اللون الافتراضي
  static const String _colorKey = 'theme_color';

  void changeColor(Color newColor) async {
    emit(newColor);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, newColor.value);
  }

  // تحميل اللون عند بدء التطبيق
  Future<void> loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt(_colorKey);
    if (savedColor != null) {
      emit(Color(savedColor));
    }
  }
}
