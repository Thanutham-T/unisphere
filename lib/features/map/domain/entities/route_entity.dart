import 'package:equatable/equatable.dart';
import 'place_entity.dart';

class RouteEntity extends Equatable {
  final String id;
  final List<PlaceEntity> waypoints;
  final List<RouteStep> steps;
  final double totalDistance; // in meters
  final int estimatedWalkingTime; // in minutes
  final int estimatedDrivingTime; // in minutes
  final String routeType; // 'walking', 'driving'

  const RouteEntity({
    required this.id,
    required this.waypoints,
    required this.steps,
    required this.totalDistance,
    required this.estimatedWalkingTime,
    required this.estimatedDrivingTime,
    required this.routeType,
  });

  @override
  List<Object?> get props => [
        id,
        waypoints,
        steps,
        totalDistance,
        estimatedWalkingTime,
        estimatedDrivingTime,
        routeType,
      ];
}

class RouteStep extends Equatable {
  final int stepNumber;
  final String instruction;
  final double distance; // in meters
  final int duration; // in seconds
  final List<LocationPoint> path;

  const RouteStep({
    required this.stepNumber,
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.path,
  });

  @override
  List<Object?> get props => [
        stepNumber,
        instruction,
        distance,
        duration,
        path,
      ];
}