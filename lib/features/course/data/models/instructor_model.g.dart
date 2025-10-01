// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstructorModel _$InstructorModelFromJson(Map<String, dynamic> json) =>
    _InstructorModel(
      instructorId: (json['instructorId'] as num).toInt(),
      status: json['status'] as String? ?? 'active',
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
    );

Map<String, dynamic> _$InstructorModelToJson(_InstructorModel instance) =>
    <String, dynamic>{
      'instructorId': instance.instructorId,
      'status': instance.status,
      'archivedAt': instance.archivedAt?.toIso8601String(),
    };
