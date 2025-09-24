import 'package:equatable/equatable.dart';

class LocationPoint extends Equatable {
  final double latitude;
  final double longitude;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final LocationPoint location;
  final String category;
  final String? imageUrl;
  final bool isFavorite;
  final Map<String, dynamic>? additionalInfo;

  const PlaceEntity({
    required this.id,
    required this.name,
    this.description,
    required this.location,
    required this.category,
    this.imageUrl,
    this.isFavorite = false,
    this.additionalInfo,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        location,
        category,
        imageUrl,
        isFavorite,
        additionalInfo,
      ];

  PlaceEntity copyWith({
    String? id,
    String? name,
    String? description,
    LocationPoint? location,
    String? category,
    String? imageUrl,
    bool? isFavorite,
    Map<String, dynamic>? additionalInfo,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}