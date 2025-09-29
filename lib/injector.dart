import 'package:get_it/get_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/config/dependency_injection/auth_injection.dart';
import 'package:unisphere/features/map/map_injection.dart';
import 'package:unisphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:unisphere/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:unisphere/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:unisphere/features/profile/domain/repositories/profile_repository.dart';
import 'package:unisphere/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:unisphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:unisphere/core/services/api_service.dart';

final getIt = GetIt.instance;

/// Main dependency injection initialization
Future<void> initCriticalServices() async {
  // Initialize local storage service
  await registerLocalStorageDI(getIt);
  
  // Initialize auth services
  await registerAuthDependencies(getIt);
  
  // Initialize profile services
  await registerProfileDependencies(getIt);
  
  // Initialize map services
  await registerMapDI(getIt);
  
  FlutterNativeSplash.remove();
}

/// Register profile dependencies
Future<void> registerProfileDependencies(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<ApiService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );

  // Blocs
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(updateProfileUseCase: getIt<UpdateProfileUseCase>()),
  );
}

/// Non-critical services initialization
Future<void> initNonCriticalServices() async {}
