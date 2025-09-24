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