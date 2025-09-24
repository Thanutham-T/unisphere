import '../../../../core/errors/failure.dart';

/// Map-specific failure classes
class MapFailure extends Failure {
  const MapFailure(super.message, {super.code});
}

class LocationFailure extends Failure {
  const LocationFailure(super.message, {super.code});
}

class PlaceFailure extends Failure {
  const PlaceFailure(super.message, {super.code});
}

class RouteFailure extends Failure {
  const RouteFailure(super.message, {super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}