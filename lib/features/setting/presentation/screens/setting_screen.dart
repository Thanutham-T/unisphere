import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unisphere/core/cubits/app_settings_cubit.dart';
import 'package:unisphere/core/cubits/app_settings_state.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<AppSettingsCubit, AppSettingsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    DropdownButton<ThemeMode>(
                      value: state.themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          context.read<AppSettingsCubit>().setThemeMode(value);
                        }
                      },
                    ),
                    DropdownButton<Locale>(
                      value: state.locale,
                      items: const [
                        DropdownMenuItem(
                          value: Locale('en', 'US'),
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: Locale('th', 'TH'),
                          child: Text('ไทย'),
                        ),
                      ],
                      onChanged: (Locale? value) {
                        if (value != null) {
                          context.read<AppSettingsCubit>().setLocale(value);
                        }
                      },
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
