import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splash_master/core/splash_master.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/config/themes/app_theme.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/core/cubits/app_settings_cubit.dart';
import 'package:unisphere/core/cubits/app_settings_state.dart';
import 'package:unisphere/injector.dart' as di;
import 'package:unisphere/l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.initCriticalServices();
  SplashMaster.initialize();
  runApp(MultiBlocProvider(
      providers: [
        RepositoryProvider<KeyValueStorageService>.value(
          value: di.getIt<KeyValueStorageService>(),
        ),
      ],
      child: const MyApp()
    )
  );

  Future.microtask(() => di.initNonCriticalServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppSettingsCubit>(
      create: (_) => AppSettingsCubit(di.getIt.get<KeyValueStorageService>()),
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Unisphere',
            themeMode: state.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('th', 'TH'), Locale('en', 'US')],
            locale: state.locale,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null && supportedLocales.contains(locale)) {
                return locale;
              }
              return state.locale ?? const Locale('en');
            },
          );
        },
      ),
    );
  }
}
