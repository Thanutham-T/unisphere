import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/event.dart';
import '../../../../core/logging/app_logger.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final int id;
  final String title;
  final String? description;
  final String? category;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String? location;
  final String status;
  final DateTime date;
  @JsonKey(name: 'created_by')
  final int createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'max_capacity')
  final int? maxCapacity; 
  @JsonKey(name: 'registration_count')
  final int registrationCount;
  @JsonKey(name: 'is_registered')
  final bool isRegistered;
  @JsonKey(name: 'is_full')
  final bool isFull;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.location,
    required this.status,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.maxCapacity,
    this.registrationCount = 0,
    this.isRegistered = false,
    this.isFull = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    try {
      AppLogger.debug('🔄 Processing event JSON: ${json['title'] ?? 'Unknown'}');
      
      return _$EventModelFromJson(json);
    } catch (e) {
      AppLogger.warning('⚠️ Error parsing event JSON, creating fallback: $e');
      
      // สร้าง fallback EventModel จาก partial JSON
      return EventModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? 'Unknown Event',
        description: json['description'],
        category: json['category'],
        imageUrl: json['image_url'],
        location: json['location'],
        status: json['status'] ?? 'active',
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        createdBy: json['created_by'] ?? 1,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
        maxCapacity: json['max_capacity'],
        registrationCount: json['registration_count'] ?? 0,
        isRegistered: json['is_registered'] ?? false,
        isFull: json['is_full'] ?? false,
      );
    }
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  // 🆕 Helper methods for capacity management
  int? get availableSpots {
    if (maxCapacity == null) return null; // Unlimited
    return maxCapacity! - registrationCount;
  }

  bool get hasCapacityLimit => maxCapacity != null;

  bool get isNearlyFull {
    if (maxCapacity == null) return false;
    return registrationCount >= (maxCapacity! * 0.8); // 80% full
  }

  double get capacityPercentage {
    if (maxCapacity == null) return 0.0;
    return registrationCount / maxCapacity!;
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      category: category,
      imageUrl: imageUrl,
      date: date,
      location: location,
      status: status,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      maxCapacity: maxCapacity,
      registrationCount: registrationCount,
      isRegistered: isRegistered,
      isFull: isFull,
    );
  }
}

@JsonSerializable()
class CreateEventRequest {
  final String title;
  final String? description;
  final String? category;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String? location;
  final DateTime date;
  @JsonKey(name: 'max_capacity')
  final int? maxCapacity; // 🆕 Optional capacity limit

  const CreateEventRequest({
    required this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.location,
    required this.date,
    this.maxCapacity, // 🆕
  });

  factory CreateEventRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventRequestToJson(this);
}

@JsonSerializable()
class UpdateEventRequest {
  final String? title;
  final String? description;
  final String? category;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String? location;
  final String? status;
  final DateTime? date;
  @JsonKey(name: 'max_capacity')
  final int? maxCapacity; // 🆕 Optional capacity limit

  const UpdateEventRequest({
    this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.location,
    this.status,
    this.date,
    this.maxCapacity, // 🆕
  });

  factory UpdateEventRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEventRequestToJson(this);
}

@JsonSerializable()
class EventRegistrationRequest {
  final String? notes;

  const EventRegistrationRequest({
    this.notes,
  });

  factory EventRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$EventRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EventRegistrationRequestToJson(this);
}