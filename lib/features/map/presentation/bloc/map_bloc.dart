import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/map_failures.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/usecases/place_usecases.dart';
import '../../domain/usecases/location_usecases.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetAllPlacesUseCase getAllPlacesUseCase;
  final SearchPlacesUseCase searchPlacesUseCase;
  final GetPlacesByCategoryUseCase getPlacesByCategoryUseCase;
  final ToggleFavoritePlaceUseCase toggleFavoritePlaceUseCase;
  final GetFavoritePlacesUseCase getFavoritePlacesUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final CalculateRouteUseCase calculateRouteUseCase;

  MapBloc({
    required this.getAllPlacesUseCase,
    required this.searchPlacesUseCase,
    required this.getPlacesByCategoryUseCase,
    required this.toggleFavoritePlaceUseCase,
    required this.getFavoritePlacesUseCase,
    required this.getCurrentLocationUseCase,
    required this.calculateRouteUseCase,
  }) : super(MapInitial()) {
    on<InitializeMap>(_onInitializeMap);
    on<LoadAllPlaces>(_onLoadAllPlaces);
    on<SearchPlaces>(_onSearchPlaces);
    on<FilterPlacesByCategory>(_onFilterPlacesByCategory);
    on<ToggleFavoritePlace>(_onToggleFavoritePlace);
    on<LoadFavoritePlaces>(_onLoadFavoritePlaces);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<CalculateRoute>(_onCalculateRoute);
    on<SelectPlace>(_onSelectPlace);
    on<ClearRoute>(_onClearRoute);
    on<ClearSelectedPlace>(_onClearSelectedPlace);
    
    // Speech-to-Text Events
    on<StartSpeechRecognition>(_onStartSpeechRecognition);
    on<StopSpeechRecognition>(_onStopSpeechRecognition);
    on<CancelSpeechRecognition>(_onCancelSpeechRecognition);
    on<SpeechRecognitionResult>(_onSpeechRecognitionResult);
    on<SpeechRecognitionError>(_onSpeechRecognitionError);
    
    // Navigation Control Events
    on<StartNavigation>(_onStartNavigation);
    on<StopNavigation>(_onStopNavigation);
    on<UpdateNavigationLocation>(_onUpdateNavigationLocation);
    on<RecalculateRoute>(_onRecalculateRoute);
    
    // Map Control Events
    on<ZoomToLocation>(_onZoomToLocation);
    on<ZoomToPlace>(_onZoomToPlace);
    on<ZoomToCampusCenter>(_onZoomToCampusCenter);
    on<FocusOnCurrentLocation>(_onFocusOnCurrentLocation);
    on<SetMapCenter>(_onSetMapCenter);
    on<SetMapZoom>(_onSetMapZoom);
  }

  Future<void> _onInitializeMap(
    InitializeMap event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    
    try {
      // Get current location first
      final locationResult = await getCurrentLocationUseCase();
      
      // Then get all places
      final placesResult = await getAllPlacesUseCase();
      
      await placesResult.fold(
        (error) async {
          emit(MapError(error));
        },
        (places) async {
          await locationResult.fold(
            (locationError) async {
              // Still show places even if location fails
              emit(MapLoaded(
                places: places,
                filteredPlaces: places,
              ));
            },
            (location) async {
              emit(MapLoaded(
                places: places,
                filteredPlaces: places,
                currentLocation: location,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(MapError(MapFailure('Failed to initialize map: $e')));
    }
  }

  Future<void> _onLoadAllPlaces(
    LoadAllPlaces event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    
    final result = await getAllPlacesUseCase();
    
    result.fold(
      (error) => emit(MapError(error)),
      (places) {
        if (state is MapLoaded) {
          final currentState = state as MapLoaded;
          emit(currentState.copyWith(
            places: places,
            filteredPlaces: places,
            clearCategory: true,
            searchQuery: '',
            isSearching: false,
          ));
        } else {
          emit(MapLoaded(
            places: places,
            filteredPlaces: places,
          ));
        }
      },
    );
  }

  Future<void> _onSearchPlaces(
    SearchPlaces event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (event.query.isEmpty) {
      emit(currentState.copyWith(
        filteredPlaces: currentState.places,
        searchQuery: '',
        isSearching: false,
        clearCategory: true,
      ));
      return;
    }
    
    emit(currentState.copyWith(isSearching: true));
    
    final result = await searchPlacesUseCase(event.query);
    
    result.fold(
      (error) => emit(MapError(error)),
      (places) {
        emit(currentState.copyWith(
          filteredPlaces: places,
          searchQuery: event.query,
          isSearching: false,
          clearCategory: true,
        ));
      },
    );
  }

  Future<void> _onFilterPlacesByCategory(
    FilterPlacesByCategory event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    final result = await getPlacesByCategoryUseCase(event.category);
    
    result.fold(
      (error) => emit(MapError(error)),
      (places) {
        emit(currentState.copyWith(
          filteredPlaces: places,
          selectedCategory: event.category,
          searchQuery: '',
          isSearching: false,
        ));
      },
    );
  }

  Future<void> _onToggleFavoritePlace(
    ToggleFavoritePlace event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final result = await toggleFavoritePlaceUseCase(event.placeId);
    
    result.fold(
      (error) => emit(MapError(error)),
      (isFavorite) {
        // Refresh the places to update favorite status
        add(LoadAllPlaces());
      },
    );
  }

  Future<void> _onLoadFavoritePlaces(
    LoadFavoritePlaces event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    final result = await getFavoritePlacesUseCase();
    
    result.fold(
      (error) => emit(MapError(error)),
      (places) {
        emit(currentState.copyWith(
          filteredPlaces: places,
          selectedCategory: 'favorites',
          searchQuery: '',
          isSearching: false,
        ));
      },
    );
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    final result = await getCurrentLocationUseCase();
    
    result.fold(
      (error) {
        if (error is PermissionFailure) {
          emit(LocationPermissionDenied());
        } else {
          emit(MapError(error));
        }
      },
      (location) {
        if (state is MapLoaded) {
          final currentState = state as MapLoaded;
          emit(currentState.copyWith(currentLocation: location));
        }
      },
    );
  }

  Future<void> _onCalculateRoute(
    CalculateRoute event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (currentState.currentLocation == null) {
      emit(MapError(LocationFailure('Current location not available')));
      return;
    }
    
    emit(RouteCalculating());
    
    final result = await calculateRouteUseCase(
      start: currentState.currentLocation!,
      end: event.destination,
      routeType: event.routeType,
      waypoints: event.waypoints,
    );
    
    result.fold(
      (error) => emit(MapError(error)),
      (route) {
        emit(currentState.copyWith(currentRoute: route));
      },
    );
  }

  Future<void> _onSelectPlace(
    SelectPlace event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(selectedPlace: event.place));
  }

  Future<void> _onClearRoute(
    ClearRoute event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(clearRoute: true));
  }

  Future<void> _onClearSelectedPlace(
    ClearSelectedPlace event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(clearSelectedPlace: true));
  }

  // Speech-to-Text Event Handlers
  Future<void> _onStartSpeechRecognition(
    StartSpeechRecognition event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    emit(SpeechRecognitionInitializing());
    
    try {
      // Clear any previous speech errors
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(
        isSpeechListening: true,
        clearSpeechError: true,
        clearSpeechResult: true,
      ));
      
      emit(SpeechRecognitionListening());
    } catch (e) {
      emit(SpeechRecognitionFailed(e.toString()));
    }
  }

  Future<void> _onStopSpeechRecognition(
    StopSpeechRecognition event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(isSpeechListening: false));
  }

  Future<void> _onCancelSpeechRecognition(
    CancelSpeechRecognition event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      isSpeechListening: false,
      clearSpeechResult: true,
      clearSpeechError: true,
    ));
  }

  Future<void> _onSpeechRecognitionResult(
    SpeechRecognitionResult event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (event.isFinal) {
      emit(SpeechRecognitionCompleted(event.result));
      emit(currentState.copyWith(
        speechResult: event.result,
        isSpeechListening: false,
        clearSpeechError: true,
      ));
      
      // Automatically search with the result
      add(SearchPlaces(event.result));
    } else {
      emit(SpeechRecognitionProcessing(event.result));
      emit(currentState.copyWith(speechResult: event.result));
    }
  }

  Future<void> _onSpeechRecognitionError(
    SpeechRecognitionError event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    emit(SpeechRecognitionFailed(event.error));
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      speechError: event.error,
      isSpeechListening: false,
      clearSpeechResult: true,
    ));
  }

  // Navigation Control Event Handlers
  Future<void> _onStartNavigation(
    StartNavigation event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    try {
      // Calculate route if we have current location
      if (currentState.currentLocation != null) {
        final routeResult = await calculateRouteUseCase(
          start: currentState.currentLocation!,
          end: event.destination,
          routeType: 'walking',
        );
        
        routeResult.fold(
          (failure) => emit(MapError(failure)),
          (route) {
            emit(NavigationStarted(
              destination: event.destination,
              destinationName: event.destinationName,
              route: route,
            ));
            
            emit(currentState.copyWith(
              isNavigating: true,
              navigationDestination: event.destination,
              navigationDestinationName: event.destinationName,
              currentRoute: route,
            ));
          },
        );
      } else {
        emit(currentState.copyWith(
          isNavigating: true,
          navigationDestination: event.destination,
          navigationDestinationName: event.destinationName,
        ));
      }
    } catch (e) {
      emit(MapError(MapFailure(e.toString())));
    }
  }

  Future<void> _onStopNavigation(
    StopNavigation event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      isNavigating: false,
      clearNavigation: true,
      clearRoute: true,
    ));
  }

  Future<void> _onUpdateNavigationLocation(
    UpdateNavigationLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (currentState.isNavigating && currentState.navigationDestination != null) {
      // Update current location
      emit(currentState.copyWith(currentLocation: event.currentLocation));
      
      // Check if we've arrived (within 50 meters)
      final distance = _calculateDistance(
        event.currentLocation,
        currentState.navigationDestination!,
      );
      
      if (distance < 0.05) { // 50 meters
        emit(NavigationCompleted(currentState.navigationDestinationName ?? 'Destination'));
        emit(currentState.copyWith(
          isNavigating: false,
          clearNavigation: true,
        ));
      } else {
        // Emit navigation in progress
        if (currentState.currentRoute != null) {
          emit(NavigationInProgress(
            destination: currentState.navigationDestination!,
            destinationName: currentState.navigationDestinationName ?? 'Destination',
            currentLocation: event.currentLocation,
            route: currentState.currentRoute!,
            remainingDistance: distance,
            estimatedTimeMinutes: (distance * 15).round(), // ~4 km/h walking speed
          ));
        }
      }
    }
  }

  Future<void> _onRecalculateRoute(
    RecalculateRoute event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (currentState.isNavigating && 
        currentState.currentLocation != null && 
        currentState.navigationDestination != null) {
      
      try {
        final routeResult = await calculateRouteUseCase(
          start: currentState.currentLocation!,
          end: currentState.navigationDestination!,
          routeType: 'walking',
        );
        
        routeResult.fold(
          (failure) => emit(MapError(failure)),
          (route) => emit(currentState.copyWith(currentRoute: route)),
        );
      } catch (e) {
        emit(MapError(MapFailure(e.toString())));
      }
    }
  }

  // Map Control Event Handlers
  Future<void> _onZoomToLocation(
    ZoomToLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      mapCenter: event.location,
      mapZoom: event.zoom ?? 16.0,
    ));
    
    emit(MapCenterChanged(event.location));
    if (event.zoom != null) {
      emit(MapZoomChanged(event.zoom!));
    }
  }

  Future<void> _onZoomToPlace(
    ZoomToPlace event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    final location = event.place.location;
    
    emit(currentState.copyWith(
      mapCenter: location,
      mapZoom: event.zoom ?? 17.0,
      selectedPlace: event.place,
    ));
    
    emit(MapCenterChanged(location));
    if (event.zoom != null) {
      emit(MapZoomChanged(event.zoom!));
    }
  }

  Future<void> _onZoomToCampusCenter(
    ZoomToCampusCenter event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    final campusCenter = LocationPoint(
      latitude: 7.0069451,
      longitude: 100.5007147,
    );
    
    emit(currentState.copyWith(
      mapCenter: campusCenter,
      mapZoom: 15.0,
    ));
    
    emit(MapCenterChanged(campusCenter));
    emit(MapZoomChanged(15.0));
  }

  Future<void> _onFocusOnCurrentLocation(
    FocusOnCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    
    if (currentState.currentLocation != null) {
      emit(currentState.copyWith(
        mapCenter: currentState.currentLocation,
        mapZoom: 18.0,
      ));
      
      emit(MapCenterChanged(currentState.currentLocation!));
      emit(MapZoomChanged(18.0));
    } else {
      // Try to get current location first
      add(GetCurrentLocation());
    }
  }

  Future<void> _onSetMapCenter(
    SetMapCenter event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(mapCenter: event.center));
    emit(MapCenterChanged(event.center));
  }

  Future<void> _onSetMapZoom(
    SetMapZoom event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;
    
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(mapZoom: event.zoom));
    emit(MapZoomChanged(event.zoom));
  }

  // Helper method for distance calculation
  double _calculateDistance(LocationPoint point1, LocationPoint point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double lat1Rad = point1.latitude * (3.14159265359 / 180);
    double lat2Rad = point2.latitude * (3.14159265359 / 180);
    double deltaLatRad = (point2.latitude - point1.latitude) * (3.14159265359 / 180);
    double deltaLngRad = (point2.longitude - point1.longitude) * (3.14159265359 / 180);

    double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}