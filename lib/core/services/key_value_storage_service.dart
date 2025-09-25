import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../utils/key_value_storage_base.dart';


class KeyValueStorageService {
  /// The key value storage instance
  final KeyValueStorageBase _keyValueStorage;
  KeyValueStorageService({required KeyValueStorageBase keyValueStorage})
    : _keyValueStorage = keyValueStorage;

  /// The name of the first time onboarding access
  static const _isFirstTimeOnboardingAccessKey =
      'isFirstTimeOnboardingAccessKey';

  /// Returns whether this is the first time the app is being used
  bool isFirstTimeOnboarding() {
    final firstLoad = _keyValueStorage.getCommon<bool>(
      _isFirstTimeOnboardingAccessKey,
    );
    if (firstLoad == null) {
      return true;
    }
    return firstLoad;
  }

  /// Sets the first time onboarding to this value.
  void setFirstTimeOnboarding(bool isFirstTime) {
    _keyValueStorage.setCommon<bool>(
      _isFirstTimeOnboardingAccessKey,
      isFirstTime,
    );
  }

  /// Clears the first time onboarding flag.
  void clearFirstTimeOnboarding() {
    _keyValueStorage.removeCommon(_isFirstTimeOnboardingAccessKey);
  }

  /// Generic methods for string storage
  Future<void> setString(String key, String value) async {
    _keyValueStorage.setCommon<String>(key, value);
  }

  Future<String?> getString(String key) async {
    return _keyValueStorage.getCommon<String>(key);
  }

  /// Remove a key from storage
  Future<void> remove(String key) async {
    _keyValueStorage.removeCommon(key);
  }

  /// Generic methods for encrypted string storage
  Future<void> setEncryptedString(String key, String value) async {
    await _keyValueStorage.setEncrypted(key, value);
  }

  Future<String?> getEncryptedString(String key) async {
    return await _keyValueStorage.getEncrypted(key);
  }

  /// Remove an encrypted key from storage
  Future<void> removeEncrypted(String key) async {
    await _keyValueStorage.removeEncrypted(key);
  }

  /// Clear all data from storage
  Future<void> clear() async {
    // Clear encrypted auth tokens
    await removeEncrypted('access_token');
    await removeEncrypted('token_type');
  }

  /// Theme setting
  /// The name of the theme setting
  static const _themeSettingKey = 'themeSettingKey';

  /// Returns theme setting
  ThemeMode getThemeMode() {
    final index = _keyValueStorage.getCommon<int>(_themeSettingKey);
    if (index == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  /// Sets the theme setting to this value.
  void setThemeMode(ThemeMode mode) {
    _keyValueStorage.setCommon<int>(_themeSettingKey, mode.index);
  }

  /// Locale setting
  /// The name of the locale setting
  static const _localeSettingKey = 'localeSettingKey';

  /// Returns locale setting
  Locale? getLocale() {
    final code = _keyValueStorage.getCommon<String>(_localeSettingKey);
    if (code == null) {
      return WidgetsBinding.instance.platformDispatcher.locale;
    }
    return Locale(code);
  }

  /// Sets the locale setting to this value.
  void setLocale(Locale locale) {
    _keyValueStorage.setCommon<String>(_localeSettingKey, locale.languageCode);
  }

  /// Clear the locale setting
  void clearLocale() {
    _keyValueStorage.removeCommon(_localeSettingKey);
  }
}

/// Registers the local storage service
Future<void> registerLocalStorageDI(GetIt getIt) async {
  await KeyValueStorageBase.init();

  getIt.registerLazySingleton<KeyValueStorageBase>(
    () => KeyValueStorageBase.instance,
  );

  getIt.registerLazySingleton<KeyValueStorageService>(
    () => KeyValueStorageService(keyValueStorage: getIt<KeyValueStorageBase>()),
  );
}
