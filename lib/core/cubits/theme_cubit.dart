import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/key_value_storage_service.dart';


class ThemeCubit extends Cubit<ThemeMode> {
  final KeyValueStorageService _keyValueStorageService;

  ThemeCubit(this._keyValueStorageService) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final mode = _keyValueStorageService.getThemeMode();
    emit(mode);
  }

  void setThemeMode(ThemeMode mode) {
    _keyValueStorageService.setThemeMode(mode);
    emit(mode);
  }

  void toggleLightDark() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newMode);
  }
}
