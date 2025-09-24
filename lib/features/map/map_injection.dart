import 'package:get_it/get_it.dart';
import 'data/datasources/local_data_source.dart';
import 'data/datasources/location_data_source.dart';
import 'data/datasources/route_data_source.dart';
import 'data/repositories/map_repository_impl.dart';
import 'domain/repositories/map_repository.dart';
import 'domain/usecases/place_usecases.dart';
import 'domain/usecases/location_usecases.dart';
import 'presentation/bloc/map_bloc.dart';

/// Registers map feature dependencies
Future<void> registerMapDI(GetIt getIt) async {
  // Data sources
  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<RouteDataSource>(
    () => OfflineRouteDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(
      localDataSource: getIt<LocalDataSource>(),
      locationDataSource: getIt<LocationDataSource>(),
      routeDataSource: getIt<RouteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetAllPlacesUseCase>(
    () => GetAllPlacesUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<SearchPlacesUseCase>(
    () => SearchPlacesUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<GetPlacesByCategoryUseCase>(
    () => GetPlacesByCategoryUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<ToggleFavoritePlaceUseCase>(
    () => ToggleFavoritePlaceUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<GetFavoritePlacesUseCase>(
    () => GetFavoritePlacesUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(getIt<MapRepository>()),
  );
  
  getIt.registerLazySingleton<CalculateRouteUseCase>(
    () => CalculateRouteUseCase(getIt<MapRepository>()),
  );

  // Bloc
  getIt.registerFactory<MapBloc>(
    () => MapBloc(
      getAllPlacesUseCase: getIt<GetAllPlacesUseCase>(),
      searchPlacesUseCase: getIt<SearchPlacesUseCase>(),
      getPlacesByCategoryUseCase: getIt<GetPlacesByCategoryUseCase>(),
      toggleFavoritePlaceUseCase: getIt<ToggleFavoritePlaceUseCase>(),
      getFavoritePlacesUseCase: getIt<GetFavoritePlacesUseCase>(),
      getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
      calculateRouteUseCase: getIt<CalculateRouteUseCase>(),
    ),
  );

  // Initialize offline data
  await getIt<MapRepository>().initializeOfflineData();
}