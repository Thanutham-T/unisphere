import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_state.freezed.dart';


@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    required ThemeMode themeMode,
    Locale? locale,
  }) = _AppSettingsState;
}
