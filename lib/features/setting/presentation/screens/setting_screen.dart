import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unisphere/core/cubits/app_settings_cubit.dart';
import 'package:unisphere/core/cubits/app_settings_state.dart';
import 'package:unisphere/l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTheme,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<AppSettingsCubit, AppSettingsState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Dropdown
                    DropdownButtonFormField<ThemeMode>(
                      decoration: InputDecoration(
                        labelText: l10n.settingsTheme,
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: state.themeMode,
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(l10n.settingsThemeSystem),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(l10n.settingsThemeLight),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(l10n.settingsThemeDark),
                        ),
                      ],
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<AppSettingsCubit>().setThemeMode(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Locale Dropdown - แก้ไขให้ handle null values
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: l10n.settingsLanguage,
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: state.locale?.languageCode ?? 'en',
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(l10n.languageEnglish),
                        ),
                        DropdownMenuItem(
                          value: 'th',
                          child: Text(l10n.languageThai),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          final locale = value == 'en' 
                              ? const Locale('en', 'US')
                              : const Locale('th', 'TH');
                          context.read<AppSettingsCubit>().setLocale(locale);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // App Information Section
                    Text(
                      l10n.settingsAppInfo,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(width: 8),
                                Text(l10n.settingsVersion),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.school),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(l10n.settingsAppName),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
