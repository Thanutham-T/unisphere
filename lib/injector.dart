import 'package:get_it/get_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:unisphere/core/services/key_value_storage_service.dart';
import 'package:unisphere/core/services/auth_service.dart';
import 'package:unisphere/core/services/image_upload_service.dart';
import 'package:unisphere/config/dependency_injection/auth_injection.dart';
import 'package:unisphere/features/map/map_injection.dart';
import 'package:unisphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:unisphere/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:unisphere/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:unisphere/features/profile/domain/repositories/profile_repository.dart';
import 'package:unisphere/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:unisphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:unisphere/core/services/api_service.dart';
import 'package:unisphere/core/network/network_client.dart';
import 'package:unisphere/features/event/data/datasources/event_remote_data_source.dart';
import 'package:unisphere/features/event/data/repositories/event_repository_impl.dart';
import 'package:unisphere/features/event/domain/repositories/event_repository.dart';
import 'package:unisphere/features/event/domain/usecases/get_events_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/get_event_by_id_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/create_event_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/update_event_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/delete_event_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/register_for_event_use_case.dart';
import 'package:unisphere/features/event/domain/usecases/unregister_from_event_use_case.dart';
import 'package:unisphere/features/event/presentation/bloc/event_bloc.dart';
import 'package:unisphere/features/announcement/data/datasources/announcement_remote_data_source.dart';
import 'package:unisphere/features/announcement/data/repositories/announcement_repository_impl.dart';
import 'package:unisphere/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:unisphere/features/announcement/domain/usecases/get_announcements_use_case.dart';
import 'package:unisphere/features/announcement/domain/usecases/create_announcement_use_case.dart';
import 'package:unisphere/features/announcement/domain/usecases/update_announcement_use_case.dart';
import 'package:unisphere/features/announcement/domain/usecases/delete_announcement_use_case.dart';
import 'package:unisphere/features/announcement/presentation/bloc/announcement_bloc.dart';

final getIt = GetIt.instance;

/// Main dependency injection initialization
Future<void> initCriticalServices() async {
  // Initialize local storage service
  await registerLocalStorageDI(getIt);
  
  // Initialize core services
  await registerCoreServices(getIt);
  
  // Initialize auth services
  await registerAuthDependencies(getIt);
  
  // Initialize profile services
  await registerProfileDependencies(getIt);
  
  // Initialize event services
  await registerEventDependencies(getIt);
  
  // Initialize announcement services
  await registerAnnouncementDependencies(getIt);
  
  // Initialize map services
  await registerMapDI(getIt);
  
  FlutterNativeSplash.remove();
}

/// Register core network dependencies
Future<void> registerCoreServices(GetIt getIt) async {
  getIt.registerLazySingleton<NetworkClient>(
    () => NetworkClient(getIt<KeyValueStorageService>()),
  );
  
  // Register ImageUploadService
  getIt.registerLazySingleton<ImageUploadService>(
    () => ImageUploadService(getIt<NetworkClient>()),
  );
  
  // Initialize AuthService
  AuthService().initialize(getIt<KeyValueStorageService>());
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

/// Register event dependencies
Future<void> registerEventDependencies(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(getIt<NetworkClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt<EventRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetEventsUseCase>(
    () => GetEventsUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<GetEventByIdUseCase>(
    () => GetEventByIdUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<CreateEventUseCase>(
    () => CreateEventUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<UpdateEventUseCase>(
    () => UpdateEventUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<DeleteEventUseCase>(
    () => DeleteEventUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<RegisterForEventUseCase>(
    () => RegisterForEventUseCase(getIt<EventRepository>()),
  );
  
  getIt.registerLazySingleton<UnregisterFromEventUseCase>(
    () => UnregisterFromEventUseCase(getIt<EventRepository>()),
  );

  // Blocs
  getIt.registerLazySingleton<EventBloc>(
    () => EventBloc(
      getIt<GetEventsUseCase>(),
      getIt<GetEventByIdUseCase>(),
      getIt<CreateEventUseCase>(),
      getIt<UpdateEventUseCase>(),
      getIt<DeleteEventUseCase>(),
      getIt<RegisterForEventUseCase>(),
      getIt<UnregisterFromEventUseCase>(),
    ),
  );
}

/// Register announcement dependencies
Future<void> registerAnnouncementDependencies(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(getIt<NetworkClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(getIt<AnnouncementRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetAnnouncementsUseCase>(
    () => GetAnnouncementsUseCase(getIt<AnnouncementRepository>()),
  );
  
  getIt.registerLazySingleton<CreateAnnouncementUseCase>(
    () => CreateAnnouncementUseCase(getIt<AnnouncementRepository>()),
  );
  
  getIt.registerLazySingleton<UpdateAnnouncementUseCase>(
    () => UpdateAnnouncementUseCase(getIt<AnnouncementRepository>()),
  );
  
  getIt.registerLazySingleton<DeleteAnnouncementUseCase>(
    () => DeleteAnnouncementUseCase(getIt<AnnouncementRepository>()),
  );

  // Blocs
  getIt.registerLazySingleton<AnnouncementBloc>(
    () => AnnouncementBloc(
      getIt<GetAnnouncementsUseCase>(),
      getIt<CreateAnnouncementUseCase>(),
      getIt<UpdateAnnouncementUseCase>(),
      getIt<DeleteAnnouncementUseCase>(),
    ),
  );
}

/// Non-critical services initialization
Future<void> initNonCriticalServices() async {}
