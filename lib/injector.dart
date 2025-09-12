import 'package:get_it/get_it.dart';

import 'package:unisphere/core/services/key_value_storage_service.dart';


final getIt = GetIt.instance;

/// Main dependency injection initialization
Future<void> initCriticalServices() async {
  // Initialize local storage service
  await registerLocalStorageDI(getIt);
}

/// Non-critical services initialization
Future<void> initNonCriticalServices() async {

}