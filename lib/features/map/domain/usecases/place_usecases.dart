import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/place_entity.dart';
import '../repositories/map_repository.dart';

class GetAllPlacesUseCase {
  final MapRepository repository;

  const GetAllPlacesUseCase(this.repository);

  Future<Either<Failure, List<PlaceEntity>>> call() async {
    return await repository.getAllPlaces();
  }
}

class SearchPlacesUseCase {
  final MapRepository repository;

  const SearchPlacesUseCase(this.repository);

  Future<Either<Failure, List<PlaceEntity>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }
    return await repository.searchPlaces(query);
  }
}

class GetPlacesByCategoryUseCase {
  final MapRepository repository;

  const GetPlacesByCategoryUseCase(this.repository);

  Future<Either<Failure, List<PlaceEntity>>> call(String category) async {
    return await repository.getPlacesByCategory(category);
  }
}

class ToggleFavoritePlaceUseCase {
  final MapRepository repository;

  const ToggleFavoritePlaceUseCase(this.repository);

  Future<Either<Failure, bool>> call(String placeId) async {
    return await repository.toggleFavoritePlace(placeId);
  }
}

class GetFavoritePlacesUseCase {
  final MapRepository repository;

  const GetFavoritePlacesUseCase(this.repository);

  Future<Either<Failure, List<PlaceEntity>>> call() async {
    return await repository.getFavoritePlaces();
  }
}