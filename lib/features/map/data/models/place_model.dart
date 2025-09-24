import 'package:latlong2/latlong.dart';
import '../../domain/entities/place_entity.dart';

class PlaceModel {
  final String id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final String category;
  final String? imageUrl;
  final bool isFavorite;
  final Map<String, dynamic>? additionalInfo;

  const PlaceModel({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.imageUrl,
    this.isFavorite = false,
    this.additionalInfo,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      isFavorite: _convertToBool(json['isFavorite']),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  // Helper method to safely convert int to bool for SQLite compatibility
  static bool _convertToBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite ? 1 : 0, // Convert bool to int for SQLite
      'additionalInfo': additionalInfo,
    };
  }

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      name: name,
      description: description,
      location: LocationPoint(
        latitude: latitude,
        longitude: longitude,
      ),
      category: category,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      additionalInfo: additionalInfo,
    );
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  factory PlaceModel.fromEntity(PlaceEntity entity) {
    return PlaceModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      latitude: entity.location.latitude,
      longitude: entity.location.longitude,
      category: entity.category,
      imageUrl: entity.imageUrl,
      isFavorite: entity.isFavorite,
      additionalInfo: entity.additionalInfo,
    );
  }
}