import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../core/errors/map_failures.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/location_data_source.dart';
import '../datasources/route_data_source.dart';

class MapRepositoryImpl implements MapRepository {
  final LocalDataSource localDataSource;
  final LocationDataSource locationDataSource;
  final RouteDataSource routeDataSource;

  const MapRepositoryImpl({
    required this.localDataSource,
    required this.locationDataSource,
    required this.routeDataSource,
  });

  @override
  Future<Either<Failure, List<PlaceEntity>>> getAllPlaces() async {
    try {
      final places = await localDataSource.getAllPlaces();
      return Right(places.map((place) => place.toEntity()).toList());
    } catch (e) {
      return Left(PlaceFailure('Failed to get places: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    try {
      final places = await localDataSource.searchPlaces(query);
      return Right(places.map((place) => place.toEntity()).toList());
    } catch (e) {
      return Left(PlaceFailure('Failed to search places: $e'));
    }
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceById(String id) async {
    try {
      final place = await localDataSource.getPlaceById(id);
      if (place != null) {
        return Right(place.toEntity());
      }
      return const Left(PlaceFailure('Place not found'));
    } catch (e) {
      return Left(PlaceFailure('Failed to get place: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlacesByCategory(String category) async {
    try {
      final places = await localDataSource.getPlacesByCategory(category);
      return Right(places.map((place) => place.toEntity()).toList());
    } catch (e) {
      return Left(PlaceFailure('Failed to get places by category: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoritePlace(String placeId) async {
    try {
      final result = await localDataSource.toggleFavoritePlace(placeId);
      return Right(result);
    } catch (e) {
      return Left(PlaceFailure('Failed to toggle favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getFavoritePlaces() async {
    try {
      final places = await localDataSource.getFavoritePlaces();
      return Right(places.map((place) => place.toEntity()).toList());
    } catch (e) {
      return Left(PlaceFailure('Failed to get favorite places: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> calculateRoute({
    required LocationPoint start,
    required LocationPoint end,
    required String routeType,
    List<LocationPoint>? waypoints,
  }) async {
    try {
      final route = await routeDataSource.calculateRoute(
        start: start,
        end: end,
        routeType: routeType,
        waypoints: waypoints,
      );
      return Right(route);
    } catch (e) {
      return Left(RouteFailure('Failed to calculate route: $e'));
    }
  }

  @override
  Future<Either<Failure, LocationPoint>> getCurrentLocation() async {
    try {
      final location = await locationDataSource.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return Left(LocationFailure('Failed to get current location: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final hasPermission = await locationDataSource.requestLocationPermission();
      return Right(hasPermission);
    } catch (e) {
      return Left(PermissionFailure('Failed to request location permission: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> initializeOfflineData() async {
    try {
      await localDataSource.initializeDatabase();
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Failed to initialize offline data: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isOfflineDataAvailable() async {
    try {
      await localDataSource.initializeDatabase();
      final places = await localDataSource.getAllPlaces();
      return Right(places.isNotEmpty);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to check offline data availability'));
    }
  }
}