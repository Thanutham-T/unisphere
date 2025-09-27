import 'package:equatable/equatable.dart';
import '../../domain/entities/place_entity.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllPlaces extends MapEvent {}

class SearchPlaces extends MapEvent {
  final String query;

  const SearchPlaces(this.query);

  @override
  List<Object> get props => [query];
}

class FilterPlacesByCategory extends MapEvent {
  final String category;

  const FilterPlacesByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class ToggleFavoritePlace extends MapEvent {
  final String placeId;

  const ToggleFavoritePlace(this.placeId);

  @override
  List<Object> get props => [placeId];
}

class LoadFavoritePlaces extends MapEvent {}

class GetCurrentLocation extends MapEvent {}

class CalculateRoute extends MapEvent {
  final LocationPoint destination;
  final String routeType;
  final List<LocationPoint>? waypoints;

  const CalculateRoute({
    required this.destination,
    required this.routeType,
    this.waypoints,
  });

  @override
  List<Object?> get props => [destination, routeType, waypoints];
}

class SelectPlace extends MapEvent {
  final PlaceEntity place;

  const SelectPlace(this.place);

  @override
  List<Object> get props => [place];
}

class ClearRoute extends MapEvent {}

class ClearSelectedPlace extends MapEvent {}

class InitializeMap extends MapEvent {}

// Speech-to-Text Events
class StartSpeechRecognition extends MapEvent {}

class StopSpeechRecognition extends MapEvent {}

class CancelSpeechRecognition extends MapEvent {}

class SpeechRecognitionResult extends MapEvent {
  final String result;
  final bool isFinal;

  const SpeechRecognitionResult({
    required this.result,
    required this.isFinal,
  });

  @override
  List<Object> get props => [result, isFinal];
}

class SpeechRecognitionError extends MapEvent {
  final String error;

  const SpeechRecognitionError(this.error);

  @override
  List<Object> get props => [error];
}

// Navigation Control Events
class StartNavigation extends MapEvent {
  final LocationPoint destination;
  final String destinationName;

  const StartNavigation({
    required this.destination,
    required this.destinationName,
  });

  @override
  List<Object> get props => [destination, destinationName];
}

class StopNavigation extends MapEvent {}

class UpdateNavigationLocation extends MapEvent {
  final LocationPoint currentLocation;

  const UpdateNavigationLocation(this.currentLocation);

  @override
  List<Object> get props => [currentLocation];
}

class RecalculateRoute extends MapEvent {}

// Map Control Events
class ZoomToLocation extends MapEvent {
  final LocationPoint location;
  final double? zoom;

  const ZoomToLocation({
    required this.location,
    this.zoom,
  });

  @override
  List<Object> get props => [location, zoom ?? 0];
}

class ZoomToPlace extends MapEvent {
  final PlaceEntity place;
  final double? zoom;

  const ZoomToPlace({
    required this.place,
    this.zoom,
  });

  @override
  List<Object> get props => [place, zoom ?? 0];
}

class ZoomToCampusCenter extends MapEvent {}

class FocusOnCurrentLocation extends MapEvent {}

class SetMapCenter extends MapEvent {
  final LocationPoint center;

  const SetMapCenter(this.center);

  @override
  List<Object> get props => [center];
}

class SetMapZoom extends MapEvent {
  final double zoom;

  const SetMapZoom(this.zoom);

  @override
  List<Object> get props => [zoom];
}