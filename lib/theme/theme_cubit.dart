import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    loadSavedTheme();
  } // الوضع الافتراضي
  static const String _themeKey = 'theme_mode';

  void toggleTheme() async {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, state.index);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themeKey);
    if (savedThemeIndex != null) {
      emit(ThemeMode.values[savedThemeIndex]);
    }
  }

  void setLightTheme() => emit(ThemeMode.light);
  void setDarkTheme() => emit(ThemeMode.dark);
}
