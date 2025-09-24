import 'dart:math';
import '../../domain/entities/place_entity.dart';
import '../../domain/entities/route_entity.dart';

abstract class RouteDataSource {
  Future<RouteEntity> calculateRoute({
    required LocationPoint start,
    required LocationPoint end,
    required String routeType,
    List<LocationPoint>? waypoints,
  });
}

class OfflineRouteDataSource implements RouteDataSource {
  @override
  Future<RouteEntity> calculateRoute({
    required LocationPoint start,
    required LocationPoint end,
    required String routeType,
    List<LocationPoint>? waypoints,
  }) async {
    // Simple offline route calculation
    // For a real implementation, you would use A* algorithm with campus walkway data
    
    final List<LocationPoint> routePoints = [];
    routePoints.add(start);
    
    // Add waypoints if provided
    if (waypoints != null) {
      routePoints.addAll(waypoints);
    }
    
    routePoints.add(end);
    
    // Calculate total distance
    double totalDistance = 0;
    final List<RouteStep> steps = [];
    
    for (int i = 0; i < routePoints.length - 1; i++) {
      final currentPoint = routePoints[i];
      final nextPoint = routePoints[i + 1];
      
      final stepDistance = _calculateDistance(currentPoint, nextPoint);
      totalDistance += stepDistance;
      
      // Create simple instruction
      String instruction;
      if (i == 0) {
        instruction = 'เริ่มต้นเดินทางจากจุดปัจจุบัน';
      } else if (i == routePoints.length - 2) {
        instruction = 'มาถึงจุดหมายปลายทาง';
      } else {
        instruction = 'เดินผ่านจุดพัก $i';
      }
      
      steps.add(RouteStep(
        stepNumber: i + 1,
        instruction: instruction,
        distance: stepDistance,
        duration: _calculateDuration(stepDistance, routeType),
        path: [currentPoint, nextPoint],
      ));
    }
    
    // Calculate estimated times
    final walkingTime = _calculateWalkingTime(totalDistance);
    final drivingTime = _calculateDrivingTime(totalDistance);
    
    return RouteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      waypoints: [], // We'll populate this with actual places if needed
      steps: steps,
      totalDistance: totalDistance,
      estimatedWalkingTime: walkingTime,
      estimatedDrivingTime: drivingTime,
      routeType: routeType,
    );
  }
  
  double _calculateDistance(LocationPoint point1, LocationPoint point2) {
    // Haversine formula for calculating distance between two coordinates
    const double earthRadius = 6371000; // Earth radius in meters
    
    final lat1Rad = _degreesToRadians(point1.latitude);
    final lat2Rad = _degreesToRadians(point2.latitude);
    final deltaLatRad = _degreesToRadians(point2.latitude - point1.latitude);
    final deltaLngRad = _degreesToRadians(point2.longitude - point1.longitude);
    
    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
  
  int _calculateDuration(double distance, String routeType) {
    // Return duration in seconds
    if (routeType == 'walking') {
      return (distance / 1.39).round(); // 5 km/h = 1.39 m/s
    } else {
      return (distance / 8.33).round(); // 30 km/h = 8.33 m/s
    }
  }
  
  int _calculateWalkingTime(double distance) {
    // Walking speed: 5 km/h = 83 meters/minute
    return (distance / 83).round();
  }
  
  int _calculateDrivingTime(double distance) {
    // Campus driving speed: 20 km/h = 333 meters/minute
    return (distance / 333).round();
  }
}