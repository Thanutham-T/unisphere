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
import 'package:unisphere/features/map/presentation/bloc/map_bloc.dart';
import 'package:unisphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:unisphere/core/cubits/app_settings_cubit.dart';
import 'package:unisphere/core/cubits/app_settings_state.dart';
import 'package:unisphere/injector.dart' as di;
import 'package:unisphere/l10n/app_localizations.dart';
import 'dart:io';

/// ======== ACCEPT ALL CERT (TESTING DEV ONLY) ========
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // Accept all certs
  }
}
/// ======== ACCEPT ALL CERT (TESTING DEV ONLY) ========


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// ======== ACCEPT ALL CERT (TESTING DEV ONLY) ========
  HttpOverrides.global = MyHttpOverrides();
  /// ======== ACCEPT ALL CERT (TESTING DEV ONLY) ========

  // Load environment variables
  await dotenv.load(fileName: ".env");
  
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
    return MultiBlocProvider(
      providers: [
        // AuthBloc จาก branch Atom
        BlocProvider<AuthBloc>(
          create: (context) => di.getIt<AuthBloc>(),
        ),
        // MapBloc for map functionality
        BlocProvider<MapBloc>(
          create: (context) => di.getIt<MapBloc>(),
        ),
        // ProfileBloc for profile functionality
        BlocProvider<ProfileBloc>(
          create: (context) => di.getIt<ProfileBloc>(),
        ),
        // AppSettingsCubit จาก development (แทน ThemeCubit)
        BlocProvider<AppSettingsCubit>(
          create: (_) => AppSettingsCubit(di.getIt.get<KeyValueStorageService>()),
        ),
      ],
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
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('th', 'TH'),
            ],
            locale: state.locale,
            localeResolutionCallback: (locale, supportedLocales) {
              // ใช้ locale จาก state ก่อน
              if (state.locale != null) {
                return state.locale;
              }
              
              // ถ้าไม่มี ให้ใช้ device locale ถ้า support
              if (locale != null) {
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              
              // default เป็น English
              return const Locale('en', 'US');
            },
          );
        },
      ),
    );
  }
}
