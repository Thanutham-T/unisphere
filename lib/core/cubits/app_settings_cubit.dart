import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/key_value_storage_service.dart';
import 'app_settings_state.dart';


class AppSettingsCubit extends Cubit<AppSettingsState> {
  final KeyValueStorageService _storage;

  AppSettingsCubit(this._storage)
    : super(const AppSettingsState(themeMode: ThemeMode.system)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final themeMode = _storage.getThemeMode();
    final locale = _storage.getLocale();

    emit(AppSettingsState(themeMode: themeMode, locale: locale));
  }

  void setThemeMode(ThemeMode mode) {
    _storage.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  void toggleLightDark() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    setThemeMode(newMode);
  }

  void setLocale(Locale locale) {
    _storage.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }

  void clearLocale() {
    _storage.clearLocale();
    emit(state.copyWith(locale: null));
  }
}
