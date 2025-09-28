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
  // Speech-to-Text States
  final bool isSpeechListening;
  final String? speechResult;
  final String? speechError;
  // Navigation States
  final bool isNavigating;
  final LocationPoint? navigationDestination;
  final String? navigationDestinationName;
  // Map Control States
  final LocationPoint? mapCenter;
  final double? mapZoom;

  const MapLoaded({
    required this.places,
    required this.filteredPlaces,
    this.selectedPlace,
    this.currentLocation,
    this.currentRoute,
    this.selectedCategory,
    this.searchQuery = '',
    this.isSearching = false,
    this.isSpeechListening = false,
    this.speechResult,
    this.speechError,
    this.isNavigating = false,
    this.navigationDestination,
    this.navigationDestinationName,
    this.mapCenter,
    this.mapZoom,
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
        isSpeechListening,
        speechResult,
        speechError,
        isNavigating,
        navigationDestination,
        navigationDestinationName,
        mapCenter,
        mapZoom,
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
    bool? isSpeechListening,
    String? speechResult,
    String? speechError,
    bool? isNavigating,
    LocationPoint? navigationDestination,
    String? navigationDestinationName,
    LocationPoint? mapCenter,
    double? mapZoom,
    bool clearSelectedPlace = false,
    bool clearRoute = false,
    bool clearCategory = false,
    bool clearSpeechResult = false,
    bool clearSpeechError = false,
    bool clearNavigation = false,
    bool clearMapCenter = false,
    bool clearMapZoom = false,
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
      isSpeechListening: isSpeechListening ?? this.isSpeechListening,
      speechResult: clearSpeechResult ? null : (speechResult ?? this.speechResult),
      speechError: clearSpeechError ? null : (speechError ?? this.speechError),
      isNavigating: isNavigating ?? this.isNavigating,
      navigationDestination: clearNavigation ? null : (navigationDestination ?? this.navigationDestination),
      navigationDestinationName: clearNavigation ? null : (navigationDestinationName ?? this.navigationDestinationName),
      mapCenter: clearMapCenter ? null : (mapCenter ?? this.mapCenter),
      mapZoom: clearMapZoom ? null : (mapZoom ?? this.mapZoom),
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

// Speech-to-Text States
class SpeechRecognitionInitializing extends MapState {}

class SpeechRecognitionListening extends MapState {}

class SpeechRecognitionProcessing extends MapState {
  final String partialResult;

  const SpeechRecognitionProcessing(this.partialResult);

  @override
  List<Object> get props => [partialResult];
}

class SpeechRecognitionCompleted extends MapState {
  final String result;

  const SpeechRecognitionCompleted(this.result);

  @override
  List<Object> get props => [result];
}

class SpeechRecognitionFailed extends MapState {
  final String error;

  const SpeechRecognitionFailed(this.error);

  @override
  List<Object> get props => [error];
}

// Navigation States
class NavigationStarted extends MapState {
  final LocationPoint destination;
  final String destinationName;
  final RouteEntity? route;

  const NavigationStarted({
    required this.destination,
    required this.destinationName,
    this.route,
  });

  @override
  List<Object?> get props => [destination, destinationName, route];
}

class NavigationInProgress extends MapState {
  final LocationPoint destination;
  final String destinationName;
  final LocationPoint currentLocation;
  final RouteEntity route;
  final double remainingDistance;
  final int estimatedTimeMinutes;

  const NavigationInProgress({
    required this.destination,
    required this.destinationName,
    required this.currentLocation,
    required this.route,
    required this.remainingDistance,
    required this.estimatedTimeMinutes,
  });

  @override
  List<Object> get props => [
        destination,
        destinationName,
        currentLocation,
        route,
        remainingDistance,
        estimatedTimeMinutes,
      ];
}

class NavigationCompleted extends MapState {
  final String destinationName;

  const NavigationCompleted(this.destinationName);

  @override
  List<Object> get props => [destinationName];
}

// Map Control States
class MapCenterChanged extends MapState {
  final LocationPoint center;

  const MapCenterChanged(this.center);

  @override
  List<Object> get props => [center];
}

class MapZoomChanged extends MapState {
  final double zoom;

  const MapZoomChanged(this.zoom);

  @override
  List<Object> get props => [zoom];
}