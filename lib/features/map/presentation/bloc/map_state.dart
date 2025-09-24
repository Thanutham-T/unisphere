import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/entities/route_entity.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<PlaceEntity> places;
  final List<PlaceEntity> filteredPlaces;
  final PlaceEntity? selectedPlace;
  final LocationPoint? currentLocation;
  final RouteEntity? currentRoute;
  final String? selectedCategory;
  final String searchQuery;
  final bool isSearching;

  const MapLoaded({
    required this.places,
    required this.filteredPlaces,
    this.selectedPlace,
    this.currentLocation,
    this.currentRoute,
    this.selectedCategory,
    this.searchQuery = '',
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [
        places,
        filteredPlaces,
        selectedPlace,
        currentLocation,
        currentRoute,
        selectedCategory,
        searchQuery,
        isSearching,
      ];

  MapLoaded copyWith({
    List<PlaceEntity>? places,
    List<PlaceEntity>? filteredPlaces,
    PlaceEntity? selectedPlace,
    LocationPoint? currentLocation,
    RouteEntity? currentRoute,
    String? selectedCategory,
    String? searchQuery,
    bool? isSearching,
    bool clearSelectedPlace = false,
    bool clearRoute = false,
    bool clearCategory = false,
  }) {
    return MapLoaded(
      places: places ?? this.places,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      selectedPlace: clearSelectedPlace ? null : (selectedPlace ?? this.selectedPlace),
      currentLocation: currentLocation ?? this.currentLocation,
      currentRoute: clearRoute ? null : (currentRoute ?? this.currentRoute),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class MapError extends MapState {
  final Failure failure;

  const MapError(this.failure);

  String get message => failure.message;

  @override
  List<Object> get props => [failure];
}

class LocationPermissionDenied extends MapState {}

class RouteCalculating extends MapState {}

class RouteCalculated extends MapState {
  final RouteEntity route;

  const RouteCalculated(this.route);

  @override
  List<Object> get props => [route];
}