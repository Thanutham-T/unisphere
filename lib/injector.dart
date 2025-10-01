import 'package:get_it/get_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/config/dependency_injection/auth_injection.dart';
import 'package:unisphere/features/map/map_injection.dart';
import 'package:unisphere/features/course/course_injector.dart';


final getIt = GetIt.instance;

/// Main dependency injection initialization
Future<void> initCriticalServices() async {
  // Initialize local storage service
  await registerLocalStorageDI(getIt);
  
  // Initialize auth services
  await registerAuthDependencies(getIt);

  FlutterNativeSplash.remove();
}

/// Non-critical services initialization
Future<void> initNonCriticalServices() async {
  await registerMapDI(getIt);
  await courseInjector(getIt);
}
