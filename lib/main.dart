import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splash_master/core/splash_master.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/config/themes/app_theme.dart';
import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unisphere/injector.dart' as di;
import 'package:unisphere/l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  await di.initCriticalServices();
  SplashMaster.initialize();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => di.getIt<AuthBloc>(),
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
      ),
    );
  }
}
