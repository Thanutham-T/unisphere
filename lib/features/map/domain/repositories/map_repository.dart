import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/place_entity.dart';
import '../entities/route_entity.dart';

abstract class MapRepository {
  // Places management
  Future<Either<Failure, List<PlaceEntity>>> getAllPlaces();
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query);
  Future<Either<Failure, PlaceEntity>> getPlaceById(String id);
  Future<Either<Failure, List<PlaceEntity>>> getPlacesByCategory(String category);
  Future<Either<Failure, bool>> toggleFavoritePlace(String placeId);
  Future<Either<Failure, List<PlaceEntity>>> getFavoritePlaces();

  // Route management
  Future<Either<Failure, RouteEntity>> calculateRoute({
    required LocationPoint start,
    required LocationPoint end,
    required String routeType, // 'walking' or 'driving'
    List<LocationPoint>? waypoints,
  });

  // Location services
  Future<Either<Failure, LocationPoint>> getCurrentLocation();
  Future<Either<Failure, bool>> requestLocationPermission();

  // Offline data management
  Future<Either<Failure, bool>> initializeOfflineData();
  Future<Either<Failure, bool>> isOfflineDataAvailable();
}