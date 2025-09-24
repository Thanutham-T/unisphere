import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../core/errors/map_failures.dart';
import '../entities/place_entity.dart';
import '../entities/route_entity.dart';
import '../repositories/map_repository.dart';

class CalculateRouteUseCase {
  final MapRepository repository;

  const CalculateRouteUseCase(this.repository);

  Future<Either<Failure, RouteEntity>> call({
    required LocationPoint start,
    required LocationPoint end,
    required String routeType,
    List<LocationPoint>? waypoints,
  }) async {
    return await repository.calculateRoute(
      start: start,
      end: end,
      routeType: routeType,
      waypoints: waypoints,
    );
  }
}

class GetCurrentLocationUseCase {
  final MapRepository repository;

  const GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LocationPoint>> call() async {
    // First check and request permission if needed
    final permissionResult = await repository.requestLocationPermission();
    
    return permissionResult.fold(
      (error) => Left(error),
      (hasPermission) async {
        if (!hasPermission) {
          return const Left(PermissionFailure('Location permission denied'));
        }
        return await repository.getCurrentLocation();
      },
    );
  }
}