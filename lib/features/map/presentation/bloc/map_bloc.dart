import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/map_failures.dart';
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
}