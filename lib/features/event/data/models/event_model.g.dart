// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  category: json['category'] as String?,
  imageUrl: json['image_url'] as String?,
  location: json['location'] as String?,
  status: json['status'] as String,
  date: DateTime.parse(json['date'] as String),
  createdBy: (json['created_by'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  maxCapacity: (json['max_capacity'] as num?)?.toInt(),
  registrationCount: (json['registration_count'] as num?)?.toInt() ?? 0,
  isRegistered: json['is_registered'] as bool? ?? false,
  isFull: json['is_full'] as bool? ?? false,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'location': instance.location,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'max_capacity': instance.maxCapacity,
      'registration_count': instance.registrationCount,
      'is_registered': instance.isRegistered,
      'is_full': instance.isFull,
    };

CreateEventRequest _$CreateEventRequestFromJson(Map<String, dynamic> json) =>
    CreateEventRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      location: json['location'] as String?,
      date: DateTime.parse(json['date'] as String),
      maxCapacity: (json['max_capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateEventRequestToJson(CreateEventRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'location': instance.location,
      'date': instance.date.toIso8601String(),
      'max_capacity': instance.maxCapacity,
    };

UpdateEventRequest _$UpdateEventRequestFromJson(Map<String, dynamic> json) =>
    UpdateEventRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      location: json['location'] as String?,
      status: json['status'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      maxCapacity: (json['max_capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateEventRequestToJson(UpdateEventRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'location': instance.location,
      'status': instance.status,
      'date': instance.date?.toIso8601String(),
      'max_capacity': instance.maxCapacity,
    };

EventRegistrationRequest _$EventRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => EventRegistrationRequest(notes: json['notes'] as String?);

Map<String, dynamic> _$EventRegistrationRequestToJson(
  EventRegistrationRequest instance,
) => <String, dynamic>{'notes': instance.notes};
