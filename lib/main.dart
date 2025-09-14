import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/config/themes/app_theme.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/injector.dart' as di;
import 'package:unisphere/l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.initCriticalServices();

  runApp(const MyApp());

  Future.microtask(() => di.initNonCriticalServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<KeyValueStorageService>.value(
          value: di.getIt<KeyValueStorageService>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Unisphere',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('th'),
          Locale('en'), 
        ],
        locale: Locale('en'),
      ),
    );
  }
}
